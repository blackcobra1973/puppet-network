# == Definition: network::if::base
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
#   $ipv4address    - required
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
define network::if::base (
  $ensure,
  $ipv4address,
  $netmask,
  $macaddress,
  $gateway = '',
  $bootproto = 'none',
  $userctl = false,
  $mtu = '',
  $ethtool_opts = '',
  $bonding_opts = undef,
  $isalias = false,
  $peerdns = false,
  $dns1 = '',
  $dns2 = '',
  $domain = '',
  $bridge = ''
) {
  # Validate our booleans
  validate_bool($userctl)
  validate_bool($isalias)
  validate_bool($peerdns)
  # Validate our regular expressions
  $states = [ '^up$', '^down$' ]
  validate_re($ensure, $states, '$ensure must be either "up" or "down".')

  $interface = $name

  # Deal with the case where $dns2 is non-empty and $dns1 is empty.
  if $dns2 != '' {
    if $dns1 == '' {
      $dns1_real = $dns2
      $dns2_real = ''
    } else {
      $dns1_real = $dns1
      $dns2_real = $dns2
    }
  } else {
    $dns1_real = $dns1
    $dns2_real = $dns2
  }

  #notify {"DNS1 is defined as: ${dns1}  DNS1 Real is defined as: ${dns1_real}":}

  if $isalias {
    $onparent = $ensure ? {
      'up'    => 'yes',
      'down'  => 'no',
      default => undef,
    }
    $iftemplate = template('network/ifcfg-alias.erb')
  } else {
    $onboot = $ensure ? {
      'up'    => 'yes',
      'down'  => 'no',
      default => undef,
    }
    $iftemplate = template('network/ifcfg-eth.erb')
  }

  file { "ifcfg-${interface}":
    ensure  => 'present',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    path    => "/etc/sysconfig/network-scripts/ifcfg-${interface}",
    content => $iftemplate,
    notify  => Service['network'],
  }
} # define network::if::base
