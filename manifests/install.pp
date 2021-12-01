# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include podman::install
class podman::install (
  String $podman_version = 'present',
  ) {
  package { 'slirp4netns':
    ensure => present,
  }
  package { 'podman':
    ensure => $podman_version,
  }
}
