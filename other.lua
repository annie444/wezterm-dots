local M = {}

---@param cfg { config: Config } | { config: Config, wezterm: Wezterm }
---@return nil
function M.apply_to_config(cfg)
  ---@type Config
  local config = cfg.config
  config.ui_key_cap_rendering = "UnixLong"
  config.notification_handling = "AlwaysShow"
  config.audible_bell = "SystemBeep"
  config.quote_dropped_files = "Posix"
  config.inactive_pane_hsb = {}
  config.inactive_pane_hsb.saturation = 0.9
  config.inactive_pane_hsb.brightness = 0.8
  config.alternate_buffer_wheel_scroll_speed = 3
  config.canonicalize_pasted_newlines = "LineFeed"
  config.default_cursor_style = "SteadyBlock"
end

return M
