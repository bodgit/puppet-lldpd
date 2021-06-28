require 'spec_helper_acceptance'

describe 'lldpd' do
  let(:pp) do
    <<-MANIFEST
      class { 'lldpd':
        class       => 1,
        enable_snmp => true,
        snmp_socket => '/var/agentx/master',
      }

      if $facts['os']['family'] == 'RedHat' {
        include epel

        Class['epel'] -> Class['lldpd']
      }

      # Need to disable IPv6
      class { 'snmp':
        agentaddress  => ['udp:127.0.0.1:161'],
        ro_network6   => [],
        rw_network6   => [],
        snmptrapdaddr => ['udp:127.0.0.1:162'],
        master        => true,
        before        => Class['lldpd'],
      }

      if $facts['os']['family'] != 'OpenBSD' {
        include snmp::client

        # Only OpenBSD ships the MIB in the lldpd package
        file { '/usr/share/snmp/mibs/LLDP-MIB.txt':
          ensure  => file,
          owner   => 0,
          group   => 0,
          mode    => '0644',
          source  => '/root/LLDP-MIB.txt',
          require => Package['snmpd'],
        }
      }
    MANIFEST
  end

  it 'applies idempotently' do
    idempotent_apply(pp)
  end

  describe package('lldpd') do
    it { is_expected.to be_installed }
  end

  describe file('/etc/sysconfig/lldpd'), if: host_inventory['facter']['os']['family'].eql?('RedHat') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match(%r{^ LLDPD_OPTIONS="-M \s 1 \s -x \s -X \s /var/agentx/master" $}x) }
  end

  describe file('/etc/default/lldpd'), if: host_inventory['facter']['os']['family'].eql?('Debian') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match(%r{^ DAEMON_ARGS="-M \s 1 \s -x \s -X \s /var/agentx/master" $}x) }
  end

  describe file('/etc/rc.conf.local'), if: host_inventory['facter']['os']['family'].eql?('OpenBSD') do
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

  describe command('lldpcli show configuration') do
    its(:stdout) do
      is_expected.to match(%r{^ \s{2} Override \s platform \s with: \s (?: #{host_inventory['facter']['kernel']} | \(none\) ) $}x)
      is_expected.to match(%r{^ \s{2} Disable \s LLDP-MED \s inventory: \s no $}x)
    end
    its(:exit_status) { is_expected.to eq 0 }
  end

  # If snmpd gets restarted (thanks Ubuntu) lldpd waits for 15 seconds before reconnecting
  describe command('sleep 20 && snmptable -v 2c -c public -m ALL 127.0.0.1 lldpLocPortTable') do
    its(:stdout) { is_expected.to match(%r{^ \s+ macAddress \s " (?: [0-9A-F]{2} \s ){6} " \s+ \S+ $}x) }
    its(:exit_status) { is_expected.to eq 0 }
  end
end
