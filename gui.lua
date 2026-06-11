local M = {}

---@param cfg { config: Config } | { config: Config, wezterm: Wezterm }
---@return nil
function M.apply_to_config(cfg)
  local config = cfg.config
  if cfg.wezterm == nil then cfg.wezterm = require("wezterm") end
  local wezterm = cfg.wezterm

  if wezterm.target_triple == "x86_64-unknown-linux-gnu" or wezterm.target_triple == "aarch64-unknown-linux-gnu" then
    wezterm.log_info("Enumerating GPUs for WebGPU support on linux")
    for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
      if gpu.backend == "Gl" and gpu.device_type == "Other" then
        config.webgpu_preferred_adapter = gpu
        break
      end
    end
    config.kde_window_background_blur = true
    config.webgpu_power_preference = "HighPerformance"
  elseif wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
    config.front_end = "WebGpu"
    config.macos_window_background_blur = 20
    config.native_macos_fullscreen_mode = true
    config.webgpu_power_preference = "LowPower"
  end

  config.animation_fps = 60
  config.max_fps = 120
end

return M
