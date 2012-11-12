
require 'spec_helper'

describe 'whether a custom auth_conf file is in use' do

  let(:fixtures_path) { File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'unit', 'facter') }

  after do
    Facter.clear
  end

  it 'when the file does not exist' do
    File.stubs(:exists?).with('/etc/puppet/auth.conf').returns(false)

    Facter.value(:custom_auth_conf).should == 'false'
  end

  describe 'using Puppet Enterprise' do

    before do
      Facter.fact('puppetversion').stubs(:value).returns('2.7.19 (Puppet Enterprise 2.6.1)')
    end

    it 'should look for auth.conf in the correct place' do
      File.expects(:exists?).with('/etc/puppetlabs/puppet/auth.conf')

      Facter.value(:custom_auth_conf)
    end
  end

  describe 'using open source Puppet' do

    before do
      Facter.fact('puppetversion').stubs(:value).returns('2.7.19')
    end

    it 'should look for auth.conf in the correct place' do
      File.expects(:exists?).with('/etc/puppet/auth.conf')

      Facter.value(:custom_auth_conf)
    end
  end

  describe 'return values' do
    before do
      File.stubs(:exists?).with('/etc/puppet/auth.conf').returns(true)
    end

    it 'when auth.conf is managed by Puppet' do
      File.stubs(:read).returns('# THIS FILE IS MANAGED BY PUPPET')

      Facter.value(:custom_auth_conf).should == 'false'
    end

    ['2.5.x_and_greater_auth.conf_with_console.fixture',
     '2.5.x_and_greater_auth.conf_without_console.fixture'].each do |file|

      it "when auth.conf is unmodified, using #{file} as a template" do

        contents = File.read("#{fixtures_path}/#{file}")

        File.stubs(:read).returns(contents)

        Facter.value(:custom_auth_conf).should == 'false'
      end

    end

    it 'when auth.conf is modified' do
      contents = File.read("#{fixtures_path}/modified.fixture")

      File.stubs(:read).returns(contents)

      Facter.value(:custom_auth_conf).should == 'true'
    end
  end

end