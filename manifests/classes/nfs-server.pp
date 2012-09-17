# File::      <tt>nfs-server.pp</tt>
# Author::    Sebastien Varrette (Sebastien.Varrette@uni.lu)
# Copyright:: Copyright (c) 2011 Sebastien Varrette
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: nfs::server
#
# Configure and manage an NFS server
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of nfs::server
# $nb_servers:: *Default*: 8. Number of NFS server processes to be started
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import nfs::server
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'nfs::server':
#             ensure => 'present'
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class nfs::server(
    $ensure     = $nfs::params::ensure,
    $nb_servers = $nfs::params::nb_servers
)
inherits nfs::client
{
    info ("Configuring nfs::server (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("nfs::server 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include nfs::server::debian }
        redhat, fedora, centos: { include nfs::server::redhat }
        default: {
            fail("Module $module_name is not supported on $operatingsystem")
        }
    }
}

# ------------------------------------------------------------------------------
# = Class: nfs::server::common
#
# Base class to be inherited by the other nfs::server classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class nfs::server::common {

    # Load the variables used in this module. Check the nfs::server-params.pp file
    require nfs::params

    # trick to handle the fact that the package for client and server may be the
    # same
    if (! defined( Package["${nfs::params::server_packagename}"] )) {
        package { "${nfs::params::server_packagename}":
            ensure  => "${nfs::server::ensure}",
        }
    }

    # TODO: deal with ensure != present
    service { 'nfs-server':
        name       => "${nfs::params::servicename}",
        hasrestart => "${nfs::params::hasrestart}",
        pattern    => "${nfs::params::processname}",
        hasstatus  => "${nfs::params::hasstatus}",
        require    => Package["${nfs::params::server_packagename}"],
    }
    if ($nfs::server::ensure == 'present') {
        Service['nfs-server'] {
            enable  => true,
            ensure  => 'running',
        }
        include concat::setup
        concat { "${nfs::params::exportsfile}":
            warn    => false,
            mode    => "${nfs::params::exportsfile_mode}",
            owner   => "${nfs::params::exportsfile_owner}",
            group   => "${nfs::params::exportsfile_group}",
            require => Package["${nfs::params::server_packagename}"],
            notify  => Service["nfs-server"],
        }

        # Header of the exports file
        concat::fragment { "${nfs::params::exportsfile}_header":
            target  => "${nfs::params::exportsfile}",
            content => template('nfs/exports_header.erb'),
            ensure  => "${nfs::server::ensure}",
            order   => 01,
        }

        # Specialize the number of NFS server processes to be started
        augeas { "${nfs::params::initconfigfile}/RPCNFSDCOUNT": 
            context => "/files/${nfs::params::initconfigfile}",
            changes => "set RPCNFSDCOUNT '\"${nfs::server::nb_servers}\"'",
            onlyif  => "get RPCNFSDCOUNT != '\"${nfs::server::nb_servers}\"'"
        }
        8674579005
    }
    else
    {
        Service['nfs-server'] {
            enable => false,
            ensure => 'stopped' ,
        }
    }


    include concat::setup


}


# ------------------------------------------------------------------------------
# = Class: nfs::server::debian
#
# Specialization class for Debian systems
class nfs::server::debian inherits nfs::server::common { }

# ------------------------------------------------------------------------------
# = Class: nfs::server::redhat
#
# Specialization class for Redhat systems
class nfs::server::redhat inherits nfs::server::common { }



