# == Definition: network::if::static
#
# Creates a normal interface with static IP address.
#
# === Parameters:
#
#   $ensure       - required - up|down
#   $ipaddress    - required
#   $netmask      - required
#   $gateway      - optional
#   $macaddress   - optional - defaults to macaddress_$title
#   $userctl      - optional - defaults to false
#   $mtu          - optional
#   $ethtool_opts - optional
#   $peerdns      - optional
#   $dns1         - optional
#   $dns2         - optional
#   $domain       - optional
#
# === Actions:
#
# Deploys the file /etc/sysconfig/network-scripts/ifcfg-$name.
#
# === Sample Usage:
#
#   network::if::static { 'eth0':
#     ensure     => 'up',
#     ipaddress  => '10.21.30.248',
#     netmask    => '255.255.255.128',
#     macaddress => $::macaddress_eth0,
#     domain     => 'is.domain.com domain.com',
#   }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2011 Mike Arnold, unless otherwise noted.
#
define network::if::static (
  $ensure,
  $ipv4address,
  $netmask,
  $gateway = '',
  $macaddress = '',
  $userctl = false,
  $mtu = '',
  $ethtool_opts = '',
  $peerdns = false,
  $dns1 = '',
  $dns2 = '',
  $domain = ''
) {
  # Validate our data
  if ! is_ip_address($ipv4address) { fail("${ipv4address} is not an IP address.") }

  if ! is_mac_address($macaddress) {
    $macaddy = getvar("::macaddress_${title}")
  } else {
    $macaddy = $macaddress
  }
  # Validate booleans
  validate_bool($userctl)

  network::if::base { $title:
    ensure       => $ensure,
    ipv4address  => $ipv4address,
    netmask      => $netmask,
    gateway      => $gateway,
    macaddress   => $macaddy,
    bootproto    => 'none',
    userctl      => $userctl,
    mtu          => $mtu,
    ethtool_opts => $ethtool_opts,
    peerdns      => $peerdns,
    dns1         => $dns1,
    dns2         => $dns2,
    domain       => $domain,
  }
} # define network::if::static
