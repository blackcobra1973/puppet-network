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
  $route_new_format         = false,
  $ip_interface_hash        = $network::ip_interface_hash,
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
#  $network_route_new        = {},
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
  if $route_new_format
  {
#    validate_hash($network_route)
    create_resources('network::route', $network_route)
  }
  else
  {
#    validate_hash($network_route)
    create_resources('network::route', $network_route)
  }

  anchor { 'network::begin':
    before => Class['network::global'],
    notify => Class['network::service'],
  }
  anchor { 'network::end':
    require => Class['network::service'],
  }

} # class network

