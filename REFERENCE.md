# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`lldpd`](#lldpd): Installs and manages the LLDP agent.
* [`lldpd::config`](#lldpdconfig)
* [`lldpd::install`](#lldpdinstall)
* [`lldpd::params`](#lldpdparams)
* [`lldpd::service`](#lldpdservice)

## Classes

### <a name="lldpd"></a>`lldpd`

Installs and manages the LLDP agent.

#### Examples

##### Declaring the class

```puppet
include lldpd
```

##### Enabling CDPv1 and CDPv2

```puppet
class { 'lldpd':
  enable_cdpv1 => true,
  enable_cdpv2 => true,
}
```

##### Enable SNMP support

```puppet
class { 'lldpd':
  enable_snmp => true,
  snmp_socket => ['127.0.0.1', 705],
}
```

#### Parameters

The following parameters are available in the `lldpd` class:

* [`addresses`](#addresses)
* [`chassis_id`](#chassis_id)
* [`class`](#class)
* [`enable_cdpv1`](#enable_cdpv1)
* [`enable_cdpv2`](#enable_cdpv2)
* [`enable_edp`](#enable_edp)
* [`enable_fdp`](#enable_fdp)
* [`enable_lldp`](#enable_lldp)
* [`enable_sonmp`](#enable_sonmp)
* [`enable_snmp`](#enable_snmp)
* [`interfaces`](#interfaces)
* [`package_name`](#package_name)
* [`service_name`](#service_name)
* [`snmp_socket`](#snmp_socket)

##### <a name="addresses"></a>`addresses`

Data type: `Optional[Array[String, 1]]`

List of IP addresses to advertise as the management addresses.

##### <a name="chassis_id"></a>`chassis_id`

Data type: `Optional[Array[String, 1]]`

List of interfaces to use for choosing the MAC address used as the chassis ID.

##### <a name="class"></a>`class`

Data type: `Optional[Integer[1, 4]]`

Set the LLDP-MED class.

##### <a name="enable_cdpv1"></a>`enable_cdpv1`

Data type: `Variant[Boolean, Enum['force']]`

Disable, enable, or force Cisco Discovery Protocol version 1. Both this and the below parameter are combined to form an overall CDP setting, not all combinations are supported by `lldpd`.

##### <a name="enable_cdpv2"></a>`enable_cdpv2`

Data type: `Variant[Boolean, Enum['force']]`

Disable, enable, or force Cisco Discovery Protocol version 2. Both this and the above parameter are combined to form an overall CDP setting, not all combinations are supported by `lldpd`.

##### <a name="enable_edp"></a>`enable_edp`

Data type: `Variant[Boolean, Enum['force']]`

Disable, enable, or force the Extreme Discovery Protocol.

##### <a name="enable_fdp"></a>`enable_fdp`

Data type: `Variant[Boolean, Enum['force']]`

Disable, enable, or force the Foundry Discovery Protocol.

##### <a name="enable_lldp"></a>`enable_lldp`

Data type: `Variant[Boolean, Enum['force']]`

Disable, enable, or force the Link Layer Discovery Protocol.

##### <a name="enable_sonmp"></a>`enable_sonmp`

Data type: `Variant[Boolean, Enum['force']]`

Disable, enable, or force the Nortel Discovery Protocol.

##### <a name="enable_snmp"></a>`enable_snmp`

Data type: `Boolean`

Enable or disable the SNMP AgentX sub-agent support.

##### <a name="interfaces"></a>`interfaces`

Data type: `Optional[Array[String, 1]]`

List of interfaces to advertise on.

##### <a name="package_name"></a>`package_name`

Data type: `String`

The name of the package.

##### <a name="service_name"></a>`service_name`

Data type: `String`

Name of the service.

##### <a name="snmp_socket"></a>`snmp_socket`

Data type: `Optional[Variant[Stdlib::Absolutepath, Tuple[Stdlib::IP::Address::NoSubnet, Stdlib::Port]]]`

The path or IP & port pair used to establish an SNMP AgentX connection.

### <a name="lldpdconfig"></a>`lldpd::config`

The lldpd::config class.

### <a name="lldpdinstall"></a>`lldpd::install`

The lldpd::install class.

### <a name="lldpdparams"></a>`lldpd::params`

The lldpd::params class.

### <a name="lldpdservice"></a>`lldpd::service`

The lldpd::service class.
