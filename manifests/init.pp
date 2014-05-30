# Class: splunkforwarder
#
# This module manages splunkforwarder
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class splunkforwarder
(
  $install_source          = 'undef',
  $deployment_server       = 'undef',
  $deployment_server_port  = 'undef',
)
 {
 package {'universalforwarder':
    source          => "${::install_source}",
    install_options => {
      "AGREETOLICENSE"         => 'Yes',
      "DEPLOYMENT_SERVER"      => "${::deployment_server}:${::deployment_server_port}",
      "LAUNCHSPLUNK"           => "1",
      "SERVICESTARTTYPE"       => "auto",
  }
}
    file { 'deploymentserver':
      ensure   => present,
      path     => "C:\\Program Files\\SplunkUniversalForwarder\\etc\\system\\local\\deploymentclient.conf",
      mode     => '0700',
      content  => template('splunkforwarder/deploymentserver.erb'),
      require  => Package['universalforwarder'],
      notify   => Service['splunkforwarder'],
    }
  service {'splunkforwarder':
    ensure  => running,
    enable  => true,
    require => Package['universalforwarder'],
  }
#file_line { 'sudo_rule':
#  path => 'C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs',
#  line => 'host = $fqdn',
#}
#ini_setting { "sample setting":
#  ensure  => present,
#  path    => 'C:\\Program Files\\SplunkUniversalForwarder\\etc\\system\\local\\inputs.conf',
#  section => 'default',
#  setting => 'host',
#  value   => "$fqdn",
#}
}