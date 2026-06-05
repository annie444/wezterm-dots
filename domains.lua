local M = {}

---@type fun(cfg: { config: Config } | { config: Config, wezterm: Wezterm }): nil
M.apply_to_config = function(cfg)
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

  local unix_domain_host = "spinoza."
  local host_success, hostname, host_err = wezterm.run_child_process({ "hostname" })
  if not host_success or not string.sub(hostname, 1, string.len(unix_domain_host)) == unix_domain_host then
    if not host_success then
      wezterm.log_error("Failed to determine if we're running on spinoza: " .. (host_err or "unknown error"))
    end
    return
  end
  local uid_success, uid_str, uid_err = wezterm.run_child_process({ "id", "-u" })
  if not uid_success or string.len(uid_str) == 0 then
    if not uid_success then wezterm.log_error("Failed to determine user ID: " .. (uid_err or "unknown error")) end
    return
  end
  local uid = tonumber(uid_str:gsub("%s+", ""))

  ---@type UnixDomain
  local spinoza_unix_domain = {
    name = "spinoza-unix",
    local_path = "/run/user/" .. uid .. "/wezterm/sock",
    no_serve_automatically = true,
  }
  config.unix_domains = config.unix_domains or {}
  table.insert(config.unix_domains, spinoza_unix_domain)
  config.default_gui_startup_args = { "connect", "spinoza-unix" }
end
return M
