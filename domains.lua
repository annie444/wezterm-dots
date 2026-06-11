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
    end
    return
  end

  ---@type UnixDomain
  local linux_domain = {
    name = "unix",
    local_echo_threshold_ms = 10,
  }
  config.unix_domains = config.unix_domains or {}
  table.insert(config.unix_domains, linux_domain)
  config.default_domain = "unix"
end

return M
