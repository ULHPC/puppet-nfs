# File::      <tt>client.pp</tt>
# Author::    Sebastien Varrette (Sebastien.Varrette@uni.lu)
# Copyright:: Copyright (c) 2011 Sebastien Varrette
# License::   GPLv3
#
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
    if (! defined( Package[$nfs::params::server_packagename] )) {
        package { $nfs::params::server_packagename:
            ensure  => $nfs::server::ensure,
        }
    }

    service { 'nfs-server':
        name       => $nfs::params::servicename,
        hasrestart => $nfs::params::hasrestart,
        pattern    => $nfs::params::processname,
        hasstatus  => $nfs::params::hasstatus,
        require    => Package[$nfs::params::server_packagename],
    }
    if ($nfs::server::ensure == 'present') {
        Service['nfs-server'] {
            enable  => true,
            ensure  => 'running',
        }
        concat { $nfs::params::exportsfile:
            warn    => false,
            mode    => $nfs::params::exportsfile_mode,
            owner   => $nfs::params::exportsfile_owner,
            group   => $nfs::params::exportsfile_group,
            require => Package[$nfs::params::server_packagename],
            notify  => Service['nfs-server'],
        }

        # Header of the exports file
        concat::fragment { "${nfs::params::exportsfile}_header":
            ensure  => $nfs::server::ensure,
            target  => $nfs::params::exportsfile,
            content => template('nfs/exports_header.erb'),
            order   => 01,
        }

        # Specialize the number of NFS server processes to be started
        augeas { "${nfs::params::initconfigfile}/RPCNFSDCOUNT":
            context => "/files/${nfs::params::initconfigfile}",
            changes => "set RPCNFSDCOUNT '${nfs::server::nb_servers}'",
            onlyif  => "get RPCNFSDCOUNT != '${nfs::server::nb_servers}'"
        }
    }
    else
    {
        Service['nfs-server'] {
            enable => false,
            ensure => 'stopped' ,
        }
    }

    # Optimization provided by Nicolas Capit
    if ($nfs::server::ensure == 'absent') {
        $optimization_ensure = 'absent'
    } else {
        $optimization_ensure = $nfs::server::optimization
    }
    class { 'sysctl':
        ensure => $optimization_ensure,
    }
    sysctl::value { 'vm.vfs_cache_pressure':
        ensure => $optimization_ensure,
        value  => '40',
    }
    sysctl::value { 'vm.dirty_background_bytes':
        ensure => $optimization_ensure,
        value  => '268435456',
    }
    sysctl::value { 'vm.dirty_bytes':
        ensure => $optimization_ensure,
        value  => '536870912',
    }

    class { 'rclocal':
        ensure => $optimization_ensure,
    }
    rclocal::update { 'NFS Tuning parameter':
        ensure => $optimization_ensure,
        source => 'puppet:///modules/nfs/rc.local.tuning'
    }

}
