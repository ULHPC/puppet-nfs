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
# $optimization:: *Default*: 'absent'. Enable the optimizations for big servers
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
    $ensure       = $nfs::params::ensure,
    $nb_servers   = $nfs::params::nb_servers,
    $optimization = $nfs::params::optimization
)
inherits nfs::client
{
    info ("Configuring nfs::server (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("nfs::server 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ! ($optimization in [ 'present', 'absent' ]) {
        fail("nfs::server 'optimized' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include nfs::server::common::debian }
        redhat, fedora, centos, rocky: { include nfs::server::common::redhat }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}

