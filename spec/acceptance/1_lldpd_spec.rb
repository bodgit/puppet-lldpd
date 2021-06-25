require 'spec_helper_acceptance'

describe 'lldpd' do
  it 'works with no errors' do
    pp = <<-EOS
      Package {
        source => $::osfamily ? {
          # $::architecture fact has gone missing on facter 3.x package currently installed
          'OpenBSD' => "http://ftp.openbsd.org/pub/OpenBSD/${::operatingsystemrelease}/packages/amd64/",
          default   => undef,
        },
      }

      class { '::lldpd':
        class       => 1,
        enable_snmp => true,
        snmp_socket => '/var/agentx/master',
      }

      if $::osfamily == 'RedHat' {
        include ::epel

        Class['::epel'] -> Class['::lldpd']
      }

      class { '::snmp':
        master => true,
        before => Class['::lldpd'],
      }

      if $::osfamily != 'OpenBSD' {
        include ::snmp::client

        # Only OpenBSD ships the MIB in the lldpd package
        file { 'LLDP-MIB.txt':
          ensure  => file,
          path    => $::osfamily ? {
            'RedHat' => '/usr/share/snmp/mibs/LLDP-MIB.txt',
            'Debian' => $::operatingsystem ? {
              'Debian' => $::operatingsystemmajrelease ? {
                7       => '/usr/share/mibs/netsnmp/LLDP-MIB',
                default => '/usr/share/snmp/mibs/LLDP-MIB.txt',
              },
              'Ubuntu' => '/usr/share/snmp/mibs/LLDP-MIB.txt',
            },
          },
          owner   => 0,
          group   => 0,
          mode    => '0644',
          source  => '/root/LLDP-MIB.txt',
          require => Package['snmpd'],
        }
      }
    EOS

    apply_manifest(pp, catch_failures: true)
    # Ubuntu 14.04 has some sort of bug that means it needs another run to get snmpd running properly
    apply_manifest(pp, catch_failures: true) if fact('operatingsystem').eql?('Ubuntu') && fact('operatingsystemrelease').eql?('14.04')
    apply_manifest(pp, catch_changes: true)
  end

  describe package('lldpd') do
    it { is_expected.to be_installed }
  end

  describe file('/etc/sysconfig/lldpd'), if: fact('osfamily').eql?('RedHat') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match(%r{^ LLDPD_OPTIONS="-M \s 1 \s -x \s -X \s /var/agentx/master" $}x) }
  end

  describe file('/etc/default/lldpd'), if: fact('osfamily').eql?('Debian') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match(%r{^ DAEMON_ARGS="-M \s 1 \s -x \s -X \s /var/agentx/master" $}x) }
  end

  describe file('/etc/rc.conf.local'), if: fact('osfamily').eql?('OpenBSD') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'wheel' }
    its(:content) { is_expected.to match(%r{^ lldpd_flags=-M \s 1 \s -x \s -X \s /var/agentx/master$}x) }
  end

  describe service('lldpd') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  # Debian 7.x has ancient version
  describe command('lldpcli show configuration'), unless: (fact('operatingsystem').eql?('Debian') and fact('operatingsystemmajrelease').eql?('7')) do
    its(:stdout) do
      is_expected.to match(%r{^ \s{2} Override \s platform \s with: \s (?: #{fact('kernel')} | \(none\) ) $}x)
      is_expected.to match(%r{^ \s{2} Disable \s LLDP-MED \s inventory: \s no $}x)
    end
    its(:exit_status) { is_expected.to eq 0 }
  end

  # Debian 8.x snmpd package is broken, Puppet thinks snmpd running but it isn't so this fails
  # If snmpd gets restarted (thanks Ubuntu) lldpd waits for 15 seconds before reconnecting
  describe command('sleep 20 && snmptable -v 2c -c public -m ALL 127.0.0.1 lldpLocPortTable'), unless: (fact('operatingsystem').eql?('Debian') and fact('operatingsystemmajrelease').eql?('8')) do
    its(:stdout) { is_expected.to match(%r{^ \s+ macAddress \s " (?: [0-9A-F]{2} \s ){6} " \s+ \S+ $}x) }
    its(:exit_status) { is_expected.to eq 0 }
  end
end
