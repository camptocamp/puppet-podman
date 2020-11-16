# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   podman::run { 'namevar': }
define podman::run (
  Optional[String] $image                   = undef,
  String[1]        $container_tag           = 'latest',
  String[1]        $user                    = 'root',
  String[1]        $group                   = 'root',
  Optional[String] $command                 = undef,
  String           $environment_file        = "/etc/sysconfig/${name}",
  Boolean          $manage_environment_file = true,
  Array            $ports                   = [],
  Array            $volumes                 = [],
  Optional[Array]  $env_vars                = undef,
  Optional[String] $container_extra_flags   = undef,
  Optional[String] $podman_extra_args       = undef,
  Optional[String] $depends_on_svc          = undef,
) {
  include ::podman

  if ($user != 'root') {
    $service_enable = undef  # Puppet's module service doesn't support of systemd user service
    $service_active = undef
    $systemd_unit_file_path = "/home/${user}/.config/systemd/user"
  }else{
    $service_enable = true
    $service_active = true
    $systemd_unit_file_path = '/etc/systemd/system'
  }

  systemd::unit_file { "${name}-container.service":
    path    => $systemd_unit_file_path,
    content => epp(
      'podman/container.service.epp',
      {
        'description'      => sprintf('%s container', capitalize($name)),
        'sanitised_title'  => regsubst($title, '[^0-9A-Za-z.\-_]', '-', 'G'),
        'environment_file' => $environment_file,
        'depends_on_svc'   => $depends_on_svc,
      }
    ),
    owner   => $user,
    group   => $group,
    enable  => $service_enable,
    active  => $service_active,
  }
  file { $environment_file:
    ensure  => file,
    path    => $environment_file,
    owner   => $user,
    group   => $group,
    content => epp(
      'podman/sysconfig.epp',
      {
        'image'                 => $image,
        'container_tag'         => $container_tag,
        'volumes'               => $volumes,
        'container_extra_flags' => $container_extra_flags,
        'podman_extra_args'     => $podman_extra_args,
        'ports'                 => $ports,
        'env_vars'              => $env_vars,
      }
    ),
    replace => $manage_environment_file,
  }
}
