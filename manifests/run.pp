# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   podman::run { 'namevar': }
define podman::run (
  String[1]        $image,
  Optional[String] $user                = 'root',
  Optional[String] $group               = 'root',
  Optional[String] $command             = undef,
  Optional[String] $container_run_flags = undef,
  Array            $ports               = [],
) {
  include ::podman
  systemd::unit_file { "${name}-container.service":
    content => epp(
      'podman/container.service.epp',
      {
        'description'         => sprintf('%s container', capitalize($name)),
        'image'               => $image,
        'user'                => $user,
        'group'               => $group,
        'sanitised_title'     => regsubst($title, '[^0-9A-Za-z.\-_]', '-', 'G'),
        'ports'               => $ports,
        'command'             => $command,
        'container_run_flags' => $container_run_flags,
      }
    ),
    enable  => true,
    active  => true,
  }
}
