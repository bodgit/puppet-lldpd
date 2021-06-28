# frozen_string_literal: true

require 'singleton'

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

RSpec.configure do |c|
  c.before :suite do
    LitmusHelper.instance.run_shell('setenforce 0', expect_failures: true) if host_inventory['facter']['os']['family'].eql?('RedHat') # EL8 needs this
    LitmusHelper.instance.run_shell('puppet module install puppet/epel')
    LitmusHelper.instance.run_shell('puppet module install puppet/snmp')
    LitmusHelper.instance.bolt_upload_file(File.join(File.dirname(__FILE__), 'fixtures/files/LLDP-MIB.txt'), '/root/LLDP-MIB.txt')
  end
end
