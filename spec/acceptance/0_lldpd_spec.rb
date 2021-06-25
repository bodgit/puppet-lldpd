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
        class => 1,
      }

      if $::osfamily == 'RedHat' {
        include ::epel

        Class['::epel'] -> Class['::lldpd']
      }
    EOS

    apply_manifest(pp, catch_failures: true)
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
    its(:content) { is_expected.to match(%r{^ LLDPD_OPTIONS="-M \s 1" $}x) }
  end

  describe file('/etc/default/lldpd'), if: fact('osfamily').eql?('Debian') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    its(:content) { is_expected.to match(%r{^ DAEMON_ARGS="-M \s 1" $}x) }
  end

  describe file('/etc/rc.conf.local'), if: fact('osfamily').eql?('OpenBSD') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'wheel' }
    its(:content) { is_expected.to match(%r{^ lldpd_flags=-M \s 1 $}x) }
  end

  describe service('lldpd') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  # Debian 7.x has ancient version
  describe command('lldpcli show configuration'), unless: (fact('osfamily').eql?('Debian') and fact('operatingsystemmajrelease').eql?('7')) do
    its(:stdout) do
      is_expected.to match(%r{^ \s{2} Override \s platform \s with: \s (?: #{fact('kernel')} | \(none\) ) $}x)
      is_expected.to match(%r{^ \s{2} Disable \s LLDP-MED \s inventory: \s no $}x)
    end
    its(:exit_status) { is_expected.to eq 0 }
  end
end
