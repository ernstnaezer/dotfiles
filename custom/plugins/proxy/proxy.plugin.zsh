#
# Proxy Switcher using Squid.
#
# proxy() changes the proxy network settings and makes this state global by managing the exlusive existence of
# ~/.proxy.on and ~/.proxy.off. It also calls proxy_envs() for convenience
#
# proxy_envs() sets the proxy environment variables based on the ~/.proxy.state file
#
# proxy_envs() is called in this file, which is assumed to be loaded in every terminal session, e.g. by sourcing it in
# .zshrc or .bashrc
#
# In conclusion: you only need to call proxy() once. After that, all apps and (new) terminal windows will work with the
# proxy
#

proxy_envs() {
  declare -a proxy_envs=(
    "http_proxy"
    "HTTP_PROXY"
    "https_proxy"
    "HTTPS_PROXY"
    "ftp_proxy"
    "FTP_PROXY"
    "rsync_proxy"
    "RSYNC_PROXY"
    "npm_config_proxy"
    "NPM_CONFIG_PROXY"
    "npm_config_https_proxy"
    "NPM_CONFIG_HTTPS_PROXY"
  )
  if [[ -e "$HOME/.proxy.on" ]]; then
    proxy_value="http://127.0.0.1:3128"
    for i in "${proxy_envs[@]}"; do export $i=$proxy_value; done
  else
    for i in "${proxy_envs[@]}"; do unset $i; done
  fi
}

proxy() {

  state=$1

  if [[ "$state" != "on" && "$state" != "off" ]]; then
    echo "Usage: proxy [on|off]."
    return 1
  fi

  if [[ "$state" == "on" ]]; then
    inverse_state="off"
  else
    inverse_state="on"
  fi

  IFS=$'\n'
  if [[ ! -e "$HOME/.proxy.$state" ]]; then

    # Ask for the administrator password upfront
    sudo -v

    echo "Turning web proxy $state for all network devices."

    for service in $(networksetup -listallnetworkservices | tail -n +2 ); do
      eval "sudo networksetup -setwebproxy '$service' 127.0.0.1 3128 off"
      eval "sudo networksetup -setsecurewebproxy '$service' 127.0.0.1 3128 off"

      eval "sudo networksetup -setwebproxystate '$service' $state"
      eval "sudo networksetup -setsecurewebproxystate '$service' $state"

      eval "sudo networksetup -setproxybypassdomains '$service' ''"
    done

    touch "$HOME/.proxy.$state"
  fi
  rm -f "$HOME/.proxy.${inverse_state}"
  unset IFS

  if [[ "$state" == "on" ]]; then
    # start squid if not already running
    if [[ -z "$(pgrep squid)" ]]; then
      /usr/local/squid/sbin/squid
    fi
  fi

  proxy_envs
}
