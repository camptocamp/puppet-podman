# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include podman::config
class podman::config {
  sysctl { 'user.max_user_namespaces':
    ensure => present,
    value  => '3154', # This is the default in RHEL8.1beta
  }
}
