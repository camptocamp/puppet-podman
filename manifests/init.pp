# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include podman
class podman {
  class { '::podman::install': }
  -> class { '::podman::config': }
}
