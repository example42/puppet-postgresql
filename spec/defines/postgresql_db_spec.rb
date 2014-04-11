require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'postgresql::db', :type => :define do

  let(:title) { 'postgresql::db' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :arch => 'i386', :operatingsystem => 'Debian', :concat_basedir => '/var/lib/puppet/concat' } }
  let(:params) {
    { 'name' => 'example42' }
  }

  describe 'Test postgresql::db with db name' do
    it { should contain_exec('postgresql_db_example42').with_command(/CREATE DATABASE example42;/) }
    it { should contain_exec('postgresql_db_example42').with_unless('psql --list -t -A | grep -q "^example42|"') }
  end

  describe 'Test postgresql::db with owner' do
    let(:params) {{
      'name' => 'example42',
      'owner' => 'example42'
    }}
    it { should contain_exec('postgresql_db_example42').with_command(/CREATE DATABASE example42 OWNER example42/) }
  end

  describe 'Test postgresql::db with template' do
    let(:params) {{
      'name' => 'example42',
      'template' => 'example42'
    }}
    it { should contain_exec('postgresql_db_example42').with_command(/CREATE DATABASE example42 TEMPLATE example42/) }
  end

  describe 'Test postgresql::db to have correct path' do
    it { should contain_exec('postgresql_db_example42').with_path(/^(.*:)?\/bin(:.*)?$/) }
    it { should contain_exec('postgresql_db_example42').with_path(/^(.*:)?\/usr\/bin(:.*)?$/) }
  end

end
