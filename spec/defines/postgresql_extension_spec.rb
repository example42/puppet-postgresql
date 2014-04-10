require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'postgresql::extension', :type => :define do

  let(:title) { 'my_extension' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :arch => 'i386', :operatingsystem => 'Debian' } }

  describe 'Test postgresql::extension should load extension' do
    it { should contain_exec('postgres-manage-extension-my_extension').with_command(/CREATE EXTENSION/) }
    it { should contain_exec('postgres-manage-extension-my_extension').without_onlyif() }
    it { should contain_exec('postgres-manage-extension-my_extension').with_user('postgres') }
    it { should contain_exec('postgres-manage-extension-my_extension').with_require(/Package/) }
  end

  describe 'Test postgresql::extension - load into database' do
    let (:params) { { :database => 'my_db' } }
    it { should contain_exec('postgres-manage-extension-my_extension').with_command(/my_db/) }
    it { should contain_exec('postgres-manage-extension-my_extension').with_require(/Postgresql::Db/) }
    it { should contain_exec('postgres-manage-extension-my_extension').with_require(/Package/) }
  end

  describe 'Test postgresql::extension - delete extension' do
    let(:params) { { :absent => true } }
    it { should contain_exec('postgres-manage-extension-my_extension').with_command(/DROP EXTENSION/) }
    it { should contain_exec('postgres-manage-extension-my_extension').without_unless() }
    it { should contain_exec('postgres-manage-extension-my_extension').with_user('postgres') }
    it { should contain_exec('postgres-manage-extension-my_extension').with_require(/Package/) }
  end
end
