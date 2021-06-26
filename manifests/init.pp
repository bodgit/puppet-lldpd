# Installs and manages the LLDP agent.
#
# @example Declaring the class
#   include lldpd
#
# @example Enabling CDPv1 and CDPv2
#   class { 'lldpd':
#     enable_cdpv1 => true,
#     enable_cdpv2 => true,
#   }
#
# @example Enable SNMP support
#   class { 'lldpd':
#     enable_snmp => true,
#     snmp_socket => ['127.0.0.1', 705],
#   }
#
# @param addresses List of IP addresses to advertise as the management addresses.
# @param chassis_id List of interfaces to use for choosing the MAC address used as the chassis ID.
# @param class Set the LLDP-MED class.
# @param enable_cdpv1 Disable, enable, or force Cisco Discovery Protocol version 1. Both this and the below parameter are combined to form an overall CDP setting, not all combinations are supported by `lldpd`.
# @param enable_cdpv2 Disable, enable, or force Cisco Discovery Protocol version 2. Both this and the above parameter are combined to form an overall CDP setting, not all combinations are supported by `lldpd`.
# @param enable_edp Disable, enable, or force the Extreme Discovery Protocol.
# @param enable_fdp Disable, enable, or force the Foundry Discovery Protocol.
# @param enable_lldp Disable, enable, or force the Link Layer Discovery Protocol.
# @param enable_sonmp Disable, enable, or force the Nortel Discovery Protocol.
# @param enable_snmp Enable or disable the SNMP AgentX sub-agent support.
# @param interfaces List of interfaces to advertise on.
# @param package_name The name of the package.
# @param service_name Name of the service.
# @param snmp_socket The path or IP & port pair used to establish an SNMP AgentX connection.
class lldpd (
  Optional[Array[String, 1]]                                                                  $addresses,
  Optional[Array[String, 1]]                                                                  $chassis_id,
  Optional[Integer[1, 4]]                                                                     $class,
  Variant[Boolean, Enum['force']]                                                             $enable_cdpv1,
  Variant[Boolean, Enum['force']]                                                             $enable_cdpv2,
  Variant[Boolean, Enum['force']]                                                             $enable_edp,
  Variant[Boolean, Enum['force']]                                                             $enable_fdp,
  Variant[Boolean, Enum['force']]                                                             $enable_lldp,
  Variant[Boolean, Enum['force']]                                                             $enable_sonmp,
  Boolean                                                                                     $enable_snmp,
  Optional[Array[String, 1]]                                                                  $interfaces,
  String                                                                                      $package_name,
  String                                                                                      $service_name,
  Optional[Variant[Stdlib::Absolutepath, Tuple[Stdlib::IP::Address::NoSubnet, Stdlib::Port]]] $snmp_socket,
) {

  contain lldpd::install
  contain lldpd::config
  contain lldpd::service

  Class['lldpd::install'] -> Class['lldpd::config'] ~> Class['lldpd::service']
}
