require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'postgresql::cluster', :type => :define do

  let(:title) { 'my_cluster' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :arch => 'i386', :operatingsystem => 'Debian' } }

  describe 'Test postgresql::cluster should create a cluster' do
    it { should contain_exec('postgres-manage-cluster-my_cluster').with_command(/pg_createcluster/) }
    it { should contain_exec('postgres-manage-cluster-my_cluster').without_onlyif() }
    it { should contain_exec('postgres-manage-cluster-my_cluster').with_require(/Package/) }
    it { should contain_exec('postgres-manage-cluster-my_cluster').with_notify(/Service/) }
  end

  describe 'Test postgresql::cluster - create cluster with locale' do
    let(:params) { { :locale => 'my_LO.UTF-8' } }
    it { should contain_exec('postgres-manage-cluster-my_cluster').with_command(/my_LO.UTF-8/) }
  end

  describe 'Test postgresql::cluster - create cluster with owner' do
    let(:params) { { :owner => 'myowner' } }
    it { should contain_exec('postgres-manage-cluster-my_cluster').with_command(/myowner/) }
  end

  describe 'Test postgresql::cluster - create cluster with group' do
    let(:params) { { :group => 'mygroup' } }
    it { should contain_exec('postgres-manage-cluster-my_cluster').with_command(/mygroup/) }
  end

  describe 'Test postgresql::cluster - delete cluster' do
    let(:params) { { :absent => true } }
    it { should contain_exec('postgres-manage-cluster-my_cluster').with_command(/pg_dropcluster/) }
    it { should contain_exec('postgres-manage-cluster-my_cluster').without_unless() }
    it { should contain_exec('postgres-manage-cluster-my_cluster').with_require(/Package/) }
  end
end
