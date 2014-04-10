require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'postgresql::role', :type => :define do

  let(:title) { 'my_role' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :arch => 'i386', :operatingsystem => 'Debian' } }

  describe 'Test postgresql::role should create a role named my_role' do
    it { should contain_exec('postgres-manage-role-my_role').with_command(/CREATE ROLE/) }
    it 'should enclose role name into double quote' do
      should contain_exec('postgres-manage-role-my_role').with_command(/\\\"my_role\\\"/)
    end
    it { should contain_exec('postgres-manage-role-my_role').without_onlyif() }
    it { should contain_exec('postgres-manage-role-my_role').with_user('postgres') }
    it { should contain_exec('postgres-manage-role-my_role').with_require(/Package/) }
  end

  describe 'Test postgresql::role - delete role' do
    let(:params) { { :absent => true } }
    it { should contain_exec('postgres-manage-role-my_role').with_command(/DROP ROLE/) }
    it 'should enclose role name into double quote' do
      should contain_exec('postgres-manage-role-my_role').with_command(/\\\"my_role\\\"/)
    end
    it { should contain_exec('postgres-manage-role-my_role').without_unless() }
    it { should contain_exec('postgres-manage-role-my_role').with_user('postgres') }
    it { should contain_exec('postgres-manage-role-my_role').with_require(/Package/) }
  end
end
