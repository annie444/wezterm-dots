local M = {}

---@type fun(cfg: { config: Config } | { config: Config, wezterm: Wezterm }): nil
M.apply_to_config = function(cfg)
  local config = cfg.config
  if cfg.wezterm == nil then cfg.wezterm = require("wezterm") end
  local wezterm = cfg.wezterm
  config.ssh_domains = wezterm.default_ssh_domains()
  ---@type SshDomain
  local spinoza_domain = {
    name = "spinoza",
    remote_address = "spinoza.ipac.caltech.edu",
    no_agent_auth = false,
    username = "annie",
    multiplexing = "WezTerm",
    local_echo_threshold_ms = 10,
    ssh_option = {
      port = 22,
      user = "annie",
      identityfile = wezterm.home_dir .. "/.ssh/ipac_ed25519",
      addkeystoagent = "yes",
      forwardagent = "yes",
      forwardx11 = "yes",
      setenv = "PINENTRY_USER_DATA=curses",
      serveraliveinterval = 60,
      serveralivecountmax = 240,
      hashknownhosts = "no",
      userknownhostsfile = wezterm.home_dir .. "/.ssh/known_hosts",
    },
  }
  table.insert(config.ssh_domains, spinoza_domain)
  config.default_workspace = "main"
end
return M
