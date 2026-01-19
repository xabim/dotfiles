luks_format_disk() {
  set -euo pipefail

  if [[ $# -lt 1 || $# -gt 4 ]]; then
    echo "Uso: luks_format_disk /dev/sdX [mapper_name] [fs_label] [mountpoint]"
    echo "Ejemplo: luks_format_disk /dev/sdb backup_usb BACKUP_USB /mnt/backup"
    return 1
  fi

  local dev="$1"
  local name="${2:-backup_usb}"
  local label="${3:-BACKUP_USB}"
  local mnt="${4:-}"

  # Requisitos
  command -v lsblk >/dev/null || { echo "Falta lsblk"; return 1; }
  command -v wipefs >/dev/null || { echo "Falta wipefs (util-linux)"; return 1; }
  command -v cryptsetup >/dev/null || { echo "Falta cryptsetup: sudo apt install cryptsetup"; return 1; }
  command -v mkfs.ext4 >/dev/null || { echo "Falta mkfs.ext4: sudo apt install e2fsprogs"; return 1; }

  [[ "$dev" == /dev/* ]] || { echo "Device inválido: $dev"; return 1; }
  [[ -b "$dev" ]] || { echo "No existe o no es un block device: $dev"; return 1; }

  # Evitar cosas peligrosas: no formatear si parece el disco del sistema (tiene / montado)
  if lsblk -no MOUNTPOINT "$dev" | grep -qE '^/$'; then
    echo "❌ $dev parece ser el disco raíz (/) — abortando."
    return 1
  fi
  if lsblk -nr "$dev" | awk '{print $7}' | grep -qE '^/$'; then
    echo "❌ Alguna partición de $dev está montada como / — abortando."
    return 1
  fi

  echo "⚠️  VAS A BORRAR COMPLETAMENTE: $dev"
  lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL "$dev"
  echo
  read -rp "Escribe EXACTAMENTE 'BORRAR $dev' para continuar: " confirm
  [[ "$confirm" == "BORRAR $dev" ]] || { echo "Cancelado."; return 1; }

  echo "🔻 Desmontando cualquier cosa montada en $dev..."
  # Desmonta particiones montadas /dev/sdX1, /dev/sdX2...
  while read -r part mp; do
    [[ -n "${mp:-}" ]] || continue
    echo "  - umount $part (montado en $mp)"
    sudo umount "$part" || true
  done < <(lsblk -nr -o NAME,MOUNTPOINT "$dev" | awk 'NF==2 {print "/dev/"$1" "$2}')

  echo "🔻 Cerrando mapper si ya existía: /dev/mapper/$name"
  if [[ -e "/dev/mapper/$name" ]]; then
    sudo cryptsetup close "$name" || true
  fi

  echo "🧹 Borrando firmas (wipefs)..."
  sudo wipefs -a "$dev"

  echo "🔐 Creando LUKS2 en $dev (te pedirá passphrase)..."
  sudo cryptsetup luksFormat \
    --type luks2 \
    --cipher aes-xts-plain64 \
    --key-size 512 \
    --hash sha256 \
    --pbkdf argon2id \
    --iter-time 3000 \
    "$dev"

  echo "🔓 Abriendo LUKS: $dev -> $name"
  sudo cryptsetup open "$dev" "$name"

  echo "🧱 Creando ext4: label=$label"
  sudo mkfs.ext4 -L "$label" "/dev/mapper/$name"

  echo "🧾 Guardando backup del header LUKS..."
  local hdr="luks-header-$(basename "$dev")-$(date +%F-%H%M%S).img"
  sudo cryptsetup luksHeaderBackup "$dev" --header-backup-file "$hdr"
  echo "✅ Header guardado en: $hdr"
  echo "   (muévelo a otro sitio seguro/offline)"

  if [[ -n "$mnt" ]]; then
    echo "📂 Montando en $mnt"
    sudo mkdir -p "$mnt"
    sudo mount -o noatime,data=ordered,commit=60 "/dev/mapper/$name" "$mnt"
    echo "✅ Montado. (Opcional) Haz tu usuario dueño del punto de montaje:"
    echo "   sudo chown -R \$USER:\$USER $mnt"
  else
    echo "ℹ️ No se montó (no diste mountpoint)."
    echo "   Para montar: sudo mount /dev/mapper/$name /mnt/backup"
  fi

  echo "🏁 Listo."
}
