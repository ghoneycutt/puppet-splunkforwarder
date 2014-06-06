# == Class: splunkforwarder
#
# This module manages splunkforwarder
#
class splunkforwarder (
  $install_source          = 'C:\Temp\splunkforwarder.msi',
  $deployment_server       = "splunk.${::domain}",
  $deployment_server_port  = '8089',
) {

  package { 'universalforwarder':
    source          => $install_source,
    install_options => {
      'AGREETOLICENSE'    => 'Yes',
      'DEPLOYMENT_SERVER' => "${deployment_server}:${deployment_server_port}",
      'LAUNCHSPLUNK'      => '1',
      'SERVICESTARTTYPE'  => 'auto',
    }
  }

  file { 'deploymentserver':
    ensure   => present,
    path     => 'C:\\Program Files\\SplunkUniversalForwarder\\etc\\system\\local\\deploymentclient.conf',
    mode     => '0700',
    content  => template('splunkforwarder/deploymentserver.erb'),
    require  => Package['universalforwarder'],
    notify   => Service['splunkforwarder'],
  }

  service { 'splunkforwarder':
    ensure  => running,
    enable  => true,
    require => Package['universalforwarder'],
  }
}
