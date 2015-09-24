#!/bin/sh
set -eu
export TERM=xterm
CONTAINERIP=$(ifconfig eth0 | grep 'inet '| grep -v 'inet6' | awk '{ print $2}')

# Bash Colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
white=`tput setaf 7`
bold=`tput bold`
reset=`tput sgr0`
separator=$(echo && printf '=%.0s' {1..100} && echo)

# Functions
log() {
  if [[ "$@" ]]; then echo "${bold}${green}[CITADEL `date +'%T'`]${reset} $@";
  else echo; fi
}

update_configurations() {
  ZONE_CONFIG="/etc/named/zone.conf"
  OPTIONS_CONFIG="/etc/named/options.conf"
  log "Updating ${bold}${white}DNS${reset} config."
  sed -i "s|\$DOMAIN|"${DOMAIN}"|g" ${OPTIONS_CONFIG}
  sed -i "s|\$DOMAIN|"${DOMAIN}"|g" ${ZONE_CONFIG}
  sed -i "s|\$CONTAINERIP|"${CONTAINERIP}"|g" ${ZONE_CONFIG}
  log "${bold}${white}DNS${reset} config updated."
  # Update userdata-keystrokes
  sed -i "s|PASSWORD|"${PASSWORD}"|g" /userdata-keystrokes
}

dns_start() {
  mv -f /etc/named/options.conf /etc/named.conf
  log "Startting ${bold}${white}DNS Server${reset}"
  named -c /etc/named.conf
  log "${bold}${white}DNS Server${reset} started."
}

atom_support() {
  if [[ ${ATOM_SUPPORT} == "true" ]]; then
    log "Atom editor support being installed."
    curl -o /usr/local/bin/rmate https://raw.githubusercontent.com/aurora/rmate/master/rmate
    chmod +x /usr/local/bin/rmate && \
    mv /usr/local/bin/rmate /usr/local/bin/atom
    log "Atom editor support added."
  fi
}

citadel_start() {
  citserver -d
  citadel-setup < /userdata-keystrokes
  webcit -p 8080 -d
}

### Magic starts here

# Install Atom support if needed
atom_support

# Update config
update_configurations

# Start DNS Server
dns_start

# Start Citadel
citadel_start
