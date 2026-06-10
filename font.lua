local M = {}

---@param cfg { config: Config } | { config: Config, wezterm: Wezterm }
---@return nil
function M.apply_to_config(cfg)
  local config = cfg.config
  if cfg.wezterm == nil then cfg.wezterm = require("wezterm") end
  local wezterm = cfg.wezterm
  config.font_size = 14.0
  config.font = wezterm.font("JetBrainsMono Nerd Font Propo")
  config.font_shaper = "Harfbuzz"
  config.harfbuzz_features = {
    "calt=1",
    "case",
    "ccmp",
    "cv03",
    "cv06",
    "cv07",
    "cv11",
    "cv14",
    "cv16",
    "cv17",
    "cv19",
    "cv99",
    "mark",
    "mkmk",
  }
  config.freetype_interpreter_version = 40
  config.anti_alias_custom_block_glyphs = true
  config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"
  config.bold_brightens_ansi_colors = "No"
  config.hyperlink_rules = wezterm.default_hyperlink_rules()
  config.warn_about_missing_glyphs = true
end

return M
