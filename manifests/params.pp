# File::      <tt>nfs-params.pp</tt>
# Author::    Sebastien Varrette (Sebastien.Varrette@uni.lu)
# Copyright:: Copyright (c) 2011 Sebastien Varrette
# License::   GPL v3
#
# ------------------------------------------------------------------------------
# = Class: nfs::params
#
# In this class are defined as variables values that are used in other
# nfs classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class nfs::params {

    ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
    # (Here are set the defaults, provide your custom variables externally)
    # (The default used is in the line with '')
    ###########################################

    # ensure the presence (or absence) of nfs
    $ensure       = 'present'
    $nb_servers   = '8'
    $optimization = 'absent'


    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################
    # Client/server packages
    $client_packagename = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => 'nfs-common',
        default => 'nfs-utils'
    }

    $server_packagename = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => 'nfs-kernel-server',
        default => 'nfs-utils'
    }
    $servicename = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/              => 'nfs-kernel-server',
        /(?i-mx:centos|fedora|redhat|rocky)/ => $::operatingsystemmajrelease ? {
          '5'     => 'nfs',
          '6'     => 'nfs',
          '7'     => 'nfs-server',
          default => 'nfs-server'
        },
        default                 => 'nfs'
    }
    # used for pattern in a service ressource
    $processname = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => 'nfsd',
        default                 => 'nfsd'
    }
    $hasstatus = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/              => false,
        /(?i-mx:centos|fedora|redhat|rocky)/ => true,
        default                              => true,
    }
    $hasrestart = $::operatingsystem ? {
        default => true,
    }

    # NFS exports file
    $exportsfile = $::operatingsystem ? {
        default => '/etc/exports',
    }
    $exportsfile_mode = $::operatingsystem ? {
        default => '0644',
    }
    $exportsfile_owner = $::operatingsystem ? {
        default => 'root',
    }
    $exportsfile_group = $::operatingsystem ? {
        default => 'root',
    }

    # NFS init script file
    $initconfigfile = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/ => '/etc/default/nfs-kernel-server',
        default => '/etc/sysconfig/nfs',
    }

}
