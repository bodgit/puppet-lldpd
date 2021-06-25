# @!visibility private
class lldpd::service {

  $flags = $facts['os']['family'] ? {
    'OpenBSD' => $lldpd::config::flags,
    default   => undef,
  }

  service { $lldpd::service_name:
    ensure     => running,
    enable     => true,
    flags      => $flags,
    hasstatus  => true,
    hasrestart => true,
  }
}
