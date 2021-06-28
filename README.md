# lldpd

[![Build Status](https://img.shields.io/github/workflow/status/bodgit/puppet-lldpd/Test)](https://github.com/bodgit/puppet-lldpd/actions?query=workflow%3ATest)
[![Codecov](https://img.shields.io/codecov/c/github/bodgit/puppet-lldpd)](https://codecov.io/gh/bodgit/puppet-lldpd)
[![Puppet Forge version](http://img.shields.io/puppetforge/v/bodgit/lldpd)](https://forge.puppetlabs.com/bodgit/lldpd)
[![Puppet Forge downloads](https://img.shields.io/puppetforge/dt/bodgit/lldpd)](https://forge.puppetlabs.com/bodgit/lldpd)
[![Puppet Forge - PDK version](https://img.shields.io/puppetforge/pdk-version/bodgit/lldpd)](https://forge.puppetlabs.com/bodgit/lldpd)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with lldpd](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with lldpd](#beginning-with-lldpd)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module installs and manages `lldpd` which provides LLDP advertisements
to connected network devices.

RHEL/CentOS, Ubuntu, Debian and OpenBSD are supported using Puppet 5 or
later.

## Setup

### Setup Requirements

On RHEL/CentOS platforms you will need to have access to the EPEL repository by
using [puppet/epel](https://forge.puppet.com/puppet/epel) or by other means.

### Beginning with lldpd

In the very simplest case, applying the module will install and start the
`lldpd` agent and enable LLDP advertisements:

```puppet
include lldpd
```

## Usage

If you want to also enable the Cisco Discovery Protocol, which comprises two
versions, use the following:

```puppet
class { 'lldpd':
  enable_cdpv1 => true,
  enable_cdpv2 => true,
}
```

Enabling the SNMP AgentX sub-agent can be done with:

```puppet
class { 'lldpd':
  enable_snmp => true,
  snmp_socket => ['127.0.0.1', 705],
}
```

## Reference

The reference documentation is generated with
[puppet-strings](https://github.com/puppetlabs/puppet-strings) and the latest
version of the documentation is hosted at
[https://bodgit.github.io/puppet-lldpd/](https://bodgit.github.io/puppet-lldpd/)
and available also in the [REFERENCE.md](https://github.com/bodgit/puppet-lldpd/blob/main/REFERENCE.md).

## Limitations

This module has been built on and tested against Puppet 5 and higher.

The module has been tested on:

* Red Hat/CentOS Enterprise Linux 6/7/8
* Ubuntu 16.04/18.04/20.04
* Debian 9/10
* OpenBSD 6.9

## Development

The module relies on [PDK](https://puppet.com/docs/pdk/1.x/pdk.html) and has
both [rspec-puppet](http://rspec-puppet.com) and
[Litmus](https://github.com/puppetlabs/puppet_litmus) tests. Run them
with:

```
$ bundle exec rake spec
$ bundle exec rake litmus:*
```

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-lldpd).
