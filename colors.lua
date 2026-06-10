local M = {}
---@param cfg { config: Config } | { config: Config, wezterm: Wezterm }
---@return nil
function M.apply_to_config(cfg)
  local config = cfg.config
  config.color_scheme = "Dracula (Official)"
  config.colors = {
    tab_bar = {
      inactive_tab_edge = "#282a36",
    },
  }
end

return M
