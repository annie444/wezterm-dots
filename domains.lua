local M = {}

---@param cfg { config: Config } | { config: Config, wezterm: Wezterm }
---@return nil
function M.apply_to_config(cfg)
  local config = cfg.config
  if cfg.wezterm == nil then cfg.wezterm = require("wezterm") end
  local wezterm = cfg.wezterm
  config.ssh_domains = wezterm.default_ssh_domains()
  ---@type SshDomain
  local spinoza_domain = {
    connect_automatically = false,
    name = "spinoza",
    remote_address = "spinoza.ipac.caltech.edu",
    no_agent_auth = false,
    username = "annie",
    multiplexing = "WezTerm",
    local_echo_threshold_ms = 10,
    ssh_option = {
      port = "22",
      user = "annie",
      identityfile = wezterm.home_dir .. "/.ssh/ipac_ed25519",
      addkeystoagent = "yes",
      forwardagent = "yes",
      forwardx11 = "yes",
      setenv = "PINENTRY_USER_DATA=curses",
      serveraliveinterval = "60",
      serveralivecountmax = "240",
      hashknownhosts = "no",
      userknownhostsfile = wezterm.home_dir .. "/.ssh/known_hosts",
    },
  }
  table.insert(config.ssh_domains, spinoza_domain)
  config.default_workspace = "main"

  local host_success, hostname_out, host_err = wezterm.run_child_process({ "hostname" })
  local hostname_str = hostname_out or ""
  local hostname = hostname_str:gsub("%s+", "")
  if (not host_success) or (hostname ~= "spinoza.ipac.caltech.edu") then
    if not host_success then
      wezterm.log_error("Failed to determine if we're running on spinoza: " .. (host_err or "unknown error"))
    else
      wezterm.log_info("Not running on spinoza, skipping unix domain configuration")
    end
    return
  end
  local uid_success, uid_out, uid_err = wezterm.run_child_process({ "id", "-ru" })
  local uid_str = uid_out or ""
  if (not uid_success) or uid_str:len() == 0 then
    if not uid_success then
      wezterm.log_error("Failed to determine user ID: " .. (uid_err or "unknown error"))
    else
      wezterm.log_error("Failed to determine user ID: empty output")
    end
    return
  end
  local uid = tonumber(uid_str)

  ---@type UnixDomain
  local spinoza_unix_domain = {
    name = "spinoza-unix",
    socket_path = "/run/user/" .. uid .. "/wezterm/sock",
    no_serve_automatically = true,
    connect_automatically = true,
  }
  config.unix_domains = config.unix_domains or {}
  table.insert(config.unix_domains, spinoza_unix_domain)
  config.default_gui_startup_args = { "connect", "spinoza-unix" }
end

return M
