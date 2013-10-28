require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'postgresql::hba', :type => :define do

  let(:title) { 'postgresql::hba' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :arch => 'i386', :operatingsystem => 'Debian', :concat_basedir => '/var/lib/puppet/concat' } }
  let(:params) { {
    :type     => 'local',
    :database => 'all',
    :user     => 'all',
    :method   => 'password'
  } }

  describe 'Test postgresql::hba require postgresql to be install' do
    it { should contain_concat('/etc/postgresql/8.4/main/pg_hba.conf').with_require(/Package/) }
  end
end
