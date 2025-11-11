local M = {}
---@type fun(cfg: { config: Config } | { config: Config, wezterm: Wezterm }): nil
M.apply_to_config = function(cfg)
	---@type Config
	local config = cfg.config
	if cfg.wezterm == nil then
		cfg.wezterm = require("wezterm")
	end
	---@type Wezterm
	local wezterm = cfg.wezterm
	---@type Action
	local act = wezterm.action

	config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 }

	local custom_keys = {
		{ key = "F11", mods = "",       action = act.ToggleFullScreen },
		{ key = " ",   mods = "LEADER", action = act.SendKey({ key = " ", mods = "CTRL" }) },
		{ key = "h",   mods = "LEADER", action = act.ActivatePaneDirection("Left") },
		{ key = "l",   mods = "LEADER", action = act.ActivatePaneDirection("Right") },
		{ key = "k",   mods = "LEADER", action = act.ActivatePaneDirection("Up") },
		{ key = "j",   mods = "LEADER", action = act.ActivatePaneDirection("Down") },
		{ key = "H",   mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "L",   mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "K",   mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "J",   mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
		{
			key = "-",
			mods = "LEADER",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "\\",
			mods = "LEADER",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{ key = ":", mods = "LEADER",     action = act.ActivateCommandPalette },
		{ key = "q", mods = "LEADER",     action = act.CloseCurrentPane({ confirm = false }) },
		{ key = "d", mods = "LEADER",     action = act.DetachDomain("CurrentPaneDomain") },
		{ key = "v", mods = "LEADER",     action = act.ActivateCopyMode },
		{ key = "x", mods = "LEADER",     action = act.ActivateCopyMode },
		{ key = "f", mods = "LEADER",     action = act.ToggleFullScreen },
		{ key = ">", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "<", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "L", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },
		{ key = "H", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
		{ key = "K", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },
		{ key = "J", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },
		{ key = "Q", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
		{ key = "C", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
		{ key = "V", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
		{ key = "X", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
		{ key = "F", mods = "CTRL|SHIFT", action = act.ToggleFullScreen },
		{ key = "D", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },
		{ key = "M", mods = "CTRL|SHIFT", action = act.ShowLauncher },
		{ key = "W", mods = "CTRL|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
		{
			key = "N",
			mods = "CTRL|SHIFT",
			action = act.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { AnsiColor = "Fuchsia" } },
					{ Text = "Enter name for new workspace" },
				}),
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:perform_action(
							act.SwitchToWorkspace({
								name = line,
							}),
							pane
						)
					end
				end),
			}),
		},
		{ key = "-",        mods = "CTRL",  action = act.DecreaseFontSize },
		{ key = "=",        mods = "CTRL",  action = act.IncreaseFontSize },
		{ key = "0",        mods = "CTRL",  action = act.ResetFontSize },
		{ key = "PageUp",   mods = "SHIFT", action = act.ScrollByPage(-1) },
		{ key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
	}

	config.keys = custom_keys

	for i = 1, 9 do
		table.insert(config.keys, 1, {
			key = tostring(i),
			mods = "CTRL|SHIFT",
			action = act.ActivateTab(i),
		})
	end

	for i = 1, 9 do
		table.insert(config.keys, 1, {
			key = tostring(i),
			mods = "LEADER",
			action = act.ActivatePaneByIndex(i),
		})
	end
end
return M

--- Commands:
-- ClearSelection
-- CloseCurrentPane
-- CloseCurrentTab
-- CompleteSelection
-- CompleteSelectionOrOpenLinkAtMouseCursor
-- Confirmation
-- Copy
-- CopyTo
-- EmitEvent
-- ExtendSelectionToMouseCursor
-- InputSelector
-- Multiple
-- Nop
-- OpenLinkAtMouseCursor
-- PaneSelect
-- Paste
-- PasteFrom
-- PastePrimarySelection
-- PopKeyTable
-- PromptInputLine
-- QuickSelect
-- QuickSelectArgs
-- QuitApplication
-- ReloadConfiguration
-- ResetFontAndWindowSize
-- ResetFontSize
-- ResetTerminal
-- RotatePanes
-- Search
-- SelectTextAtMouseCursor
-- SendKey
-- SendString
-- SetWindowLevel
-- Show
-- ShowDebugOverlay
-- ShowLauncher
-- ShowLauncherArgs
-- ShowTabNavigator
-- ToggleAlwaysOnBottom
-- ToggleAlwaysOnTop
-- TogglePaneZoomState
