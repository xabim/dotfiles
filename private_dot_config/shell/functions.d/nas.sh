#!/usr/bin/env bash
# Sourceable + ejecutable: backup cifrado (LUKS) desde Synology por SMB (CIFS) + rsync
# SMB con password interactiva (NO credentials file)

# ====== Configuración ======
NAS_IP="${NAS_IP:-192.168.1.100}"

DEVICE="${DEVICE:-/dev/sdb}"
CRYPT_NAME="${CRYPT_NAME:-backup_usb}"

MOUNT_BACKUP="${MOUNT_BACKUP:-/mnt/backup}"
MOUNT_NAS="${MOUNT_NAS:-/mnt/nas}"

SMB_VERS="${SMB_VERS:-3.1.1}"

# Usuario SMB (se puede exportar por env o se pedirá)
SMB_USER="${SMB_USER:-}"

# SMART (en USB a veces hace falta -d sat)
SMART_DEVTYPE="${SMART_DEVTYPE:--d sat}"

# Log rsync
RSYNC_LOG="${RSYNC_LOG:-/tmp/rsync-backup.log}"

_backup_log() { echo "[$(date '+%F %T')] $*"; }
_backup_die() { _backup_log "❌ $*"; return 1; }
_backup_is_mounted() { mountpoint -q "$1"; }

# ---------- SMART ----------
backup_smart_check() {
  command -v smartctl >/dev/null 2>&1 || _backup_die "smartctl no encontrado. Instala: sudo apt install smartmontools"

  _backup_log "🧠 SMART check en $DEVICE ..."
  local out
  out="$(sudo smartctl -a ${SMART_DEVTYPE} "$DEVICE" 2>/dev/null)" || _backup_die "smartctl falló leyendo $DEVICE"

  echo "$out" | grep -q "SMART overall-health self-assessment test result: PASSED" \
    || _backup_die "SMART overall-health NO es PASSED"

  local realloc pending offline crc
  realloc="$(echo "$out" | awk '/Reallocated_Sector_Ct/ {print $NF; exit}')"
  pending="$(echo "$out" | awk '/Current_Pending_Sector/ {print $NF; exit}')"
  offline="$(echo "$out" | awk '/Offline_Uncorrectable/ {print $NF; exit}')"
  crc="$(echo "$out" | awk '/UDMA_CRC_Error_Count/ {print $NF; exit}')"
  realloc="${realloc:-0}"; pending="${pending:-0}"; offline="${offline:-0}"; crc="${crc:-0}"

  if [[ "$realloc" != "0" || "$pending" != "0" || "$offline" != "0" ]]; then
    _backup_die "SMART alerta: Reallocated=$realloc Pending=$pending Offline=$offline (aborto)"
  fi
  if [[ "$crc" != "0" ]]; then
    _backup_log "⚠️  SMART aviso: UDMA_CRC_Error_Count=$crc (cable/bridge USB-SATA probable)"
  fi

  _backup_log "✅ SMART OK"
}

# ---------- LUKS / mounts ----------
backup_open() {
  command -v cryptsetup >/dev/null 2>&1 || _backup_die "cryptsetup no encontrado. Instala: sudo apt install cryptsetup"
  sudo mkdir -p "$MOUNT_BACKUP" "$MOUNT_NAS"

  _backup_log "🔓 Abriendo LUKS: $DEVICE -> $CRYPT_NAME"
  if [[ ! -e "/dev/mapper/$CRYPT_NAME" ]]; then
    sudo cryptsetup open "$DEVICE" "$CRYPT_NAME"
  fi

  if ! _backup_is_mounted "$MOUNT_BACKUP"; then
    _backup_log "📂 Montando backup en $MOUNT_BACKUP"
    sudo mount "/dev/mapper/$CRYPT_NAME" "$MOUNT_BACKUP"
  fi
}

backup_close() {
  _backup_log "🔒 Cerrando mounts y LUKS..."
  if _backup_is_mounted "$MOUNT_NAS"; then sudo umount "$MOUNT_NAS" || true; fi
  if _backup_is_mounted "$MOUNT_BACKUP"; then sudo umount "$MOUNT_BACKUP" || true; fi
  if [[ -e "/dev/mapper/$CRYPT_NAME" ]]; then sudo cryptsetup close "$CRYPT_NAME" || true; fi
  _backup_log "🏁 Cerrado."
}

# ---------- SMB mount ----------
backup_smb_mount() {
  command -v mount.cifs >/dev/null 2>&1 || _backup_die "cifs-utils no encontrado. Instala: sudo apt install cifs-utils"

  local share="$1"
  [[ -n "$share" ]] || _backup_die "backup_smb_mount requiere un share (ej: others)"

  if [[ -z "$SMB_USER" ]]; then
    read -rp "Usuario SMB: " SMB_USER
  fi

  if _backup_is_mounted "$MOUNT_NAS"; then
    sudo umount "$MOUNT_NAS" || true
  fi

  local unc="//${NAS_IP}/${share}"
  _backup_log "🌐 Montando SMB: ${unc} -> $MOUNT_NAS"

  # Pedirá password de forma interactiva
  sudo mount -t cifs "$unc" "$MOUNT_NAS" \
    -o "username=${SMB_USER},vers=${SMB_VERS},iocharset=utf8,uid=$(id -u),gid=$(id -g),noperm,soft"
}

# ---------- Backup de un share ----------
backup_one() {
  local share="$1"
  [[ -n "$share" ]] || _backup_die "backup_one requiere un share (ej: others)"

  backup_smb_mount "$share"

  local dst_dir="${MOUNT_BACKUP}/${share}"
  mkdir -p "$dst_dir"

  _backup_log "🔁 rsync SMB->backup: ${share}/ -> ${dst_dir}/"
  rsync -a --delete \
    --info=progress2,stats2 \
    --no-motd \
    --partial --partial-dir=.rsync-partial \
    --log-file="$RSYNC_LOG" \
    "${MOUNT_NAS}/" "${dst_dir}/"

  _backup_log "✅ Share '$share' completado"
}

# ---------- Backup de múltiples shares ----------
backup_many() {
  if [[ $# -lt 1 ]]; then
    _backup_die "Uso: backup_many others video [vip ...]"
    return 1
  fi

  set -euo pipefail
  trap 'rc=$?; _backup_log "⚠️  Abortado (rc=$rc). Limpiando..."; backup_close; exit $rc' INT TERM ERR

  backup_smart_check
  backup_open

  for s in "$@"; do
    backup_one "$s"
  done

  sync
  backup_close
  trap - INT TERM ERR
}

backup_usage() {
  cat <<EOF
Uso:
  source ~/.backup-nas-smb.sh
  backup_many others video

Variables opcionales:
  export SMB_USER=tu_usuario
  export NAS_IP=192.168.1.100
EOF
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  [[ $# -gt 0 ]] || { backup_usage; exit 1; }
  backup_many "$@"
fi
