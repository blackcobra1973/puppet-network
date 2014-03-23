# == Class: network
#
# This module manages Red Hat/Fedora network configuration.
#
# === Parameters:
#
# None
#
# === Actions:
#
# Defines the network service so that other resources can notify it to restart.
#
# === Sample Usage:
#
#   include 'network'
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2011 Mike Arnold, unless otherwise noted.
#
class network (
  $hostname                 = '',
  $gateway                  = '',
  $gatewaydev               = '',
  $nisdomain                = '',
  $vlan                     = '',
  $ipv6_support             = '',
  $nozeroconf               = '',
  $network_alias            = {},
  $network_alias_range      = {},
  $network_bond_bridge      = {},
  $network_bond_dynamic     = {},
  $network_bond_slave       = {},
  $network_bond_static      = {},
  $network_bridge_dynamic   = {},
  $network_bridge_static    = {},
  $network_if_bridge        = {},
  $network_if_dynamic       = {},
  $network_if_static        = {},
  $network_route            = {},
)
{
  # Only run on RedHat derived systems.
  case $::osfamily {
    'RedHat': { }
    default: {
      fail('This network module only supports RedHat-based systems.')
    }
  }

#  include stdlib

  class { 'network::service':
  }

  class { 'network::global':
    hostname       => $hostname,
    gateway        => $gateway,
    gatewaydev     => $gatewaydev,
    nisdomain      => $nisdomain,
    vlan           => $vlan,
    ipv6_support   => $ipv6_support,
    nozeroconf     => $nozeroconf,
  }

  validate_hash($network_alias)
  create_resources('network::alias', $network_alias)
  validate_hash($network_alias_range)
  create_resources('network::alias::range', $network_alias_range)
  validate_hash($network_bond_bridge)
  create_resources('network::bond::bridge', $network_bond_bridge)
  validate_hash($network_bond_dynamic)
  create_resources('network::bond::bridge', $network_bond_dynamic)
  validate_hash($network_bond_slave)
  create_resources('network::bond::bridge', $network_bond_slave)
  validate_hash($network_bond_static)
  create_resources('network::bond::bridge', $network_bond_static)
  validate_hash($network_bridge_dynamic)
  create_resources('network::bridge::dynamic', $network_bridge_dynamic)
  validate_hash($network_bridge_static)
  create_resources('network::bridge::static', $network_bridge_static)
  validate_hash($network_if_bridge)
  create_resources('network::if::bridge', $network_if_bridge)
  validate_hash($network_if_dynamic)
  create_resources('network::if::dynamic', $network_if_dynamic)
  validate_hash($network_if_static)
  create_resources('network::if::static', $network_if_static)
  validate_hash($network_route)
  create_resources('network::route', $network_route)

  anchor { 'network::begin':
    before => Class['network::global'],
    notify => Class['network::service'],
  }
  anchor { 'network::end':
    require => Class['network::service'],
  }


#  service { 'network':
#    ensure     => 'running',
#    enable     => true,
#    hasrestart => true,
#    hasstatus  => true,
#  }
} # class network

# == Definition: network_if_base
#
# This definition is private, i.e. it is not intended to be called directly
# by users.  It can be used to write out the following device files:
#  /etc/sysconfig/networking-scripts/ifcfg-eth
#  /etc/sysconfig/networking-scripts/ifcfg-eth:alias
#  /etc/sysconfig/networking-scripts/ifcfg-bond(master)
#
# === Parameters:
#
#   $ensure       - required - up|down
#   $ipaddress    - required
#   $netmask      - required
#   $macaddress   - required
#   $gateway      - optional
#   $bootproto    - optional
#   $userctl      - optional - defaults to false
#   $mtu          - optional
#   $ethtool_opts - optional
#   $bonding_opts - optional
#   $isalias      - optional
#   $peerdns      - optional
#   $dns1         - optional
#   $dns2         - optional
#   $domain       - optional
#   $bridge       - optional
#
# === Actions:
#
# Performs 'service network restart' after any changes to the ifcfg file.
#
# === TODO:
#
#   METRIC=
#   HOTPLUG=yes|no
#   WINDOW=
#   SCOPE=
#   SRCADDR=
#   NOZEROCONF=yes
#   PERSISTENT_DHCLIENT=yes|no|1|0
#   DHCPRELEASE=yes|no|1|0
#   DHCLIENT_IGNORE_GATEWAY=yes|no|1|0
#   LINKDELAY=
#   REORDER_HDR=yes|no
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2011 Mike Arnold, unless otherwise noted.
#
####  Not used anymore
#define network_if_base (
#  $ensure,
#  $ipaddress,
#  $netmask,
#  $macaddress,
#  $gateway = '',
#  $bootproto = 'none',
#  $userctl = false,
#  $mtu = '',
#  $ethtool_opts = '',
#  $bonding_opts = undef,
#  $isalias = false,
#  $peerdns = false,
#  $dns1 = '',
#  $dns2 = '',
#  $domain = '',
#  $bridge = ''
#) {
  # Validate our booleans
#  validate_bool($userctl)
#  validate_bool($isalias)
#  validate_bool($peerdns)
  # Validate our regular expressions
#  $states = [ '^up$', '^down$' ]
#  validate_re($ensure, $states, '$ensure must be either "up" or "down".')

#  include 'network'

#  $interface = $name

  # Deal with the case where $dns2 is non-empty and $dns1 is empty.
#  if $dns2 != '' {
#    if $dns1 == '' {
#      $dns1_real = $dns2
#      $dns2_real = ''
#    } else {
#      $dns1_real = $dns1
#      $dns2_real = $dns2
#    }
#  } else {
#    $dns1_real = $dns1
#    $dns2_real = $dns2
#  }

#  if $isalias {
#    $onparent = $ensure ? {
#      'up'    => 'yes',
#      'down'  => 'no',
#      default => undef,
#    }
#    $iftemplate = template('network/ifcfg-alias.erb')
#  } else {
#    $onboot = $ensure ? {
#      'up'    => 'yes',
#      'down'  => 'no',
#      default => undef,
#    }
#    $iftemplate = template('network/ifcfg-eth.erb')
#  }

#  file { "ifcfg-${interface}":
#    ensure  => 'present',
#    mode    => '0644',
#    owner   => 'root',
#    group   => 'root',
#    path    => "/etc/sysconfig/network-scripts/ifcfg-${interface}",
#    content => $iftemplate,
#    notify  => Service['network'],
#  }
#} # define network_if_base
