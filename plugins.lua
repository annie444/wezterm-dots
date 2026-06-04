local M = {}

---@param config Config
---@param wezterm Wezterm
local function sync_panes_plugin(config, wezterm)
  local sync_panes = wezterm.plugin.require("https://github.com/annie444/sync-panes.wez")
  sync_panes.apply_to_config(config)
end

---@param config Config
---@param wezterm Wezterm
local function session_manager_plugin(_, wezterm)
  local session_manager = require("wezterm-session-manager/session-manager")
  wezterm.on("save_session", function(window) session_manager.save_state(window) end)
  wezterm.on("load_session", function(window) session_manager.load_state(window) end)
  wezterm.on("restore_session", function(window) session_manager.restore_state(window) end)
end

---@param config Config
---@param wezterm Wezterm
local function cmd_sender_plugin(config, wezterm)
  local cmd_sender = wezterm.plugin.require("https://github.com/aureolebigben/wezterm-cmd-sender")
  cmd_sender.apply_to_config(config, {
    key = "mapped:s",
    mods = "CTRL|SHIFT",
    description = "Enter command to send to all panes of active tab",
  })
end

---@param config Config
---@param wezterm Wezterm
local function tabline_plugin(config, wezterm)
  local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
  tabline.setup({
    options = {
      icons_enabled = true,
      theme = "Dracula (Official)",
      tabs_enabled = true,
      theme_overrides = {},
      section_separators = {
        left = wezterm.nerdfonts.ple_right_half_circle_thick,
        right = wezterm.nerdfonts.ple_left_half_circle_thick,
      },
      component_separators = {
        left = "┃",
        right = "┃",
      },
      tab_separators = {
        left = wezterm.nerdfonts.ple_right_half_circle_thick,
        right = wezterm.nerdfonts.ple_left_half_circle_thick,
      },
    },
    sections = {
      tabline_a = { "mode" },
      tabline_b = { "workspace" },
      tabline_c = { " " },
      tab_active = {
        "index",
        { "parent", padding = 0 },
        "/",
        { "cwd", padding = { left = 0, right = 1 } },
        { "zoomed", padding = 0 },
      },
      tab_inactive = {
        "index",
        { "process", padding = { left = 0, right = 1 } },
        { "output", icon_no_output = "" },
      },
      tabline_x = { "ram", "cpu" },
      tabline_y = { "datetime", "battery" },
      tabline_z = { "domain" },
    },
    extensions = {},
  })
  tabline.apply_to_config(config)
end

---@param config Config
---@param wezterm Wezterm
local function workspace_switcher_plugin(config, wezterm)
  local workspace_switcher = wezterm.plugin.require("https://github.com/isseii10/workspace-picker.wezterm")
  workspace_switcher.setup({
    keybinds = {
      show_picker = { mods = "LEADER", key = "s" },
      create_workspace = { mods = "LEADER", key = "S" },
      rename_workspace = { mods = "LEADER", key = "r" },
    },
  })
  workspace_switcher.apply_to_config(config)
end

---@type fun(cfg: { config: Config } | { config: Config, wezterm: Wezterm }): nil
M.apply_to_config = function(cfg)
  local config = cfg.config
  if cfg.wezterm == nil then cfg.wezterm = require("wezterm") end
  local wezterm = cfg.wezterm

  cmd_sender_plugin(config, wezterm)
  tabline_plugin(config, wezterm)
  session_manager_plugin(config, wezterm)
  workspace_switcher_plugin(config, wezterm)
  sync_panes_plugin(config, wezterm)
end

return M
