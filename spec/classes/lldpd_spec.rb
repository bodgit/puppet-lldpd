require 'spec_helper'

describe 'lldpd' do
  context 'on unsupported distributions' do
    let(:facts) do
      {
        osfamily: 'Unsupported'
      }
    end

    it { expect { is_expected.to compile }.to raise_error(%r{not supported on an Unsupported}) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('lldpd') }
      it { is_expected.to contain_class('lldpd::config') }
      it { is_expected.to contain_class('lldpd::install') }
      it { is_expected.to contain_class('lldpd::params') }
      it { is_expected.to contain_class('lldpd::service') }
      it { is_expected.to contain_file('/etc/lldpd.d') }
      it { is_expected.to contain_package('lldpd') }
      it { is_expected.to contain_service('lldpd') }

      if facts[:osfamily].eql?('RedHat')
        it { is_expected.to contain_file('/etc/sysconfig/lldpd') }
      else
        it { is_expected.not_to contain_file('/etc/sysconfig/lldpd') }
      end

      if facts[:osfamily].eql?('Debian')
        it { is_expected.to contain_file('/etc/default/lldpd') }
      else
        it { is_expected.not_to contain_file('/etc/default/lldpd') }
      end

      context 'with CDP enabled' do
        let(:params) do
          {
            enable_cdpv1: true,
            enable_cdpv2: true,
          }
        end

        it { is_expected.to compile.with_all_deps }

        case facts[:osfamily]
        when 'RedHat'
          it {
            is_expected.to contain_file('/etc/sysconfig/lldpd').with_content(<<-EOS.gsub(%r{^ +}, ''))
            # !!! Managed by Puppet !!!
            LLDPD_OPTIONS="-c"
            EOS
          }
        when 'Debian'
          it {
            is_expected.to contain_file('/etc/default/lldpd').with_content(<<-EOS.gsub(%r{^ +}, ''))
            # !!! Managed by Puppet !!!
            DAEMON_ARGS="-c"
            EOS
          }
        when 'OpenBSD'
          it { is_expected.to contain_service('lldpd').with_flags('-c') }
        end
      end

      context 'with invalid CDP parameters' do
        let(:params) do
          {
            enable_cdpv1: true,
            enable_cdpv2: false,
          }
        end

        it { expect { is_expected.to compile }.to raise_error(%r{Invalid combination of CDP parameters}) }
      end

      context 'setting the LLDP-MED class' do
        let(:params) do
          {
            class: 1,
          }
        end

        it { is_expected.to compile.with_all_deps }

        case facts[:osfamily]
        when 'RedHat'
          it {
            is_expected.to contain_file('/etc/sysconfig/lldpd').with_content(<<-EOS.gsub(%r{^ +}, ''))
            # !!! Managed by Puppet !!!
            LLDPD_OPTIONS="-M 1"
            EOS
          }
        when 'Debian'
          it {
            is_expected.to contain_file('/etc/default/lldpd').with_content(<<-EOS.gsub(%r{^ +}, ''))
            # !!! Managed by Puppet !!!
            DAEMON_ARGS="-M 1"
            EOS
          }
        when 'OpenBSD'
          it { is_expected.to contain_service('lldpd').with_flags('-M 1') }
        end
      end
    end
  end
end
