local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

config = wezterm.config_builder()

config = {
  automatically_reload_config = true,
  enable_tab_bar = true,
  window_close_confirmation = "NeverPrompt",
  native_macos_fullscreen_mode = true,
  window_decorations = "RESIZE", -- disable the title bar but enable the resizable borders
  default_cursor_style = "BlinkingBar",
  color_scheme = "Nord (Gogh)",
  font = wezterm.font("JetBrains Mono", { weight = "Bold" }),
  font_size = 25,
  window_padding = {
    left = 3,
    right = 3,
    top = 0,
    bottom = 0,
  },
  keys = {
    -- This will create a new split and run your default program inside it
    {
      key = 'd',
      mods = 'SUPER|SHIFT',
      action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" })
    },
    -- This will create a new split and run your default program inside it
    {
      key = 'd',
      mods = 'SUPER',
      action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" })
    },
    {
      key = "F11",
      mods = "NONE",
      action = wezterm.action.ToggleFullScreen,
    },
    -- Or for Alt+Enter
    {
      key = "Enter",
      mods = "SUPER",
      action = wezterm.action.ToggleFullScreen,
    },
  }
}

return config