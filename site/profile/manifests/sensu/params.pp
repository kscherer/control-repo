# Common params for sensu plugins
class profile::sensu::params {
  $nagios_plugin_dir = '/usr/lib/nagios/plugins'
  $sensu_plugin_dir = '/etc/sensu/plugins'
  $check_path = "PATH=${nagios_plugin_dir}:${sensu_plugin_dir}"
}
