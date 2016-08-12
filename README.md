# Deprecation notice

This module was designed for Puppet versions 2 and 3. It should work also on Puppet 4 but doesn't use any of its features.

The current Puppet 3 compatible codebase is no longer actively maintained by example42.

Still, Pull Requests that fix bugs or introduce backwards compatible features will be accepted.


# Puppet module: postgresql

This is a Puppet module for postgresql based on the second generation layout ("NextGen") of Example42 Puppet Modules.

Made by Alessandro Franceschi / Lab42

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-postgresql

Released under the terms of Apache 2 License.

This module requires functions provided by the Example42 Puppi module (you need it even if you don't use and install Puppi)

For detailed info about the logic and usage patterns of Example42 modules check the DOCS directory on Example42 main modules set.

## USAGE - Basic management

* Install postgresql with default settings

        class { 'postgresql': }

* Install a specific version of postgresql package

        class { 'postgresql':
          version => '1.0.1',
        }

* Disable postgresql service.

        class { 'postgresql':
          disable => true
        }

* Remove postgresql package

        class { 'postgresql':
          absent => true
        }

* Enable auditing without without making changes on existing postgresql configuration files

        class { 'postgresql':
          audit_only => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'postgresql':
          source => [ "puppet:///modules/lab42/postgresql/postgresql.conf-${hostname}" , "puppet:///modules/lab42/postgresql/postgresql.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'postgresql':
          source_dir       => 'puppet:///modules/lab42/postgresql/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'postgresql':
          template => 'example42/postgresql/postgresql.conf.erb',
        }

* Automatically include a custom subclass

        class { 'postgresql':
          my_class => 'postgresql::example42',
        }


## USAGE - Example42 extensions management 
* Activate puppi (recommended, but disabled by default)

        class { 'postgresql':
          puppi    => true,
        }

* Activate puppi and use a custom puppi_helper template (to be provided separately with a puppi::helper define ) to customize the output of puppi commands 

        class { 'postgresql':
          puppi        => true,
          puppi_helper => 'myhelper', 
        }

* Activate automatic monitoring (recommended, but disabled by default). This option requires the usage of Example42 monitor and relevant monitor tools modules

        class { 'postgresql':
          monitor      => true,
          monitor_tool => [ 'nagios' , 'monit' , 'munin' ],
        }

* Activate automatic firewalling. This option requires the usage of Example42 firewall and relevant firewall tools modules

        class { 'postgresql':       
          firewall      => true,
          firewall_tool => 'iptables',
          firewall_src  => '10.42.0.0/24',
          firewall_dst  => $ipaddress_eth0,
        }


[![Build Status](https://travis-ci.org/example42/puppet-postgresql.png?branch=master)](https://travis-ci.org/example42/puppet-postgresql)
