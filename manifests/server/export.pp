# File::      <tt>nfs-server-export.pp</tt>
# Author::    Sebastien Varrette (<Sebastien.Varrette@uni.lu>)
# Copyright:: Copyright (c) 2011 Sebastien Varrette (www[http://varrette.gforge.uni.lu])
# License::   GPLv3
# ------------------------------------------------------------------------------
# = Defines: nfs::server::export
#
# This definition configure a specific directory to be exported by the NFS server
#
# == Pre-requisites
#
# * The class 'nfs::server' should have been instanciated
#
# == Parameters:
#
# [*ensure*]
#   default to 'present', can be 'absent'.
#   Default: 'present'
#
# [*allowed_hosts*]
#   Specification of the hosts which can mount this exported directory.
#   Default: '*'
#
# [*content*]
#  Specify the contents of the export entry as a string. Newlines, tabs,
#  and spaces can be specified using the escaped syntax (e.g., \n for a newline)
#
# [*source*]
#  Copy a file as the content of the export entry.
#  Uses checksum to determine when a file should be copied.
#  Valid values are either fully qualified paths to files, or URIs. Currently
#  supported URI types are puppet and file.
#
# [*comment*]
#  An optional comment to add on top of the export entry
#
# [*order*]
#  Set the order of the export entry (typically between 10 and 90).
#  Default: 50
#
# [*options*]
#  the option for the export .
#  Default: 'sync,rw,no_root_squash,no_subtree_check'
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     include 'nfs::server'
#
#      nfs::server::export { '/exports/homedirs':
#          ensure        => 'present',
#          comment       => 'Homedir of cluster users',
#          allowed_hosts => '192.168.200.0/24',
#      }
#
#    The above setting will result in the following configuration of the
#    /etc/exports file:
#
#    [...]
#    #### Homedir of cluster users
#    /exports/homedirs      192.168.200.0/24(sync,rw,no_root_squash,no_subtree_check)
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define nfs::server::export(
    $ensure        = 'present',
    $content       = '',
    $source        = '',
    $order         = '50',
    $options       = 'sync,rw,no_root_squash,no_subtree_check',
    $allowed_hosts = '*',
    $comment       = ''
)
{

    include nfs::params

    # $name is provided by define invocation and is should be set to the
    # directory path
    $dirname = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("nfs::server::export 'ensure' parameter must be set to either 'absent', or 'present'")
    }
    if ($nfs::server::ensure != $ensure) {
        if ($nfs::server::ensure != 'present') {
            fail("Cannot configure the NFS export directory '${dirname}' as nfs::server::ensure is NOT set to present (but ${nfs::server::ensure})")
        }
    }

    if ($ensure == 'present') {
        concat::fragment { "${nfs::params::exportsfile}_${dirname}":
            target => $nfs::params::exportsfile,
            order  => $order,
            notify => Service['nfs-server'],
        }

        # if content is passed, use that, else if source is passed use that
        if ($content == '' and $source != '') {
            Concat::Fragment["${nfs::params::exportsfile}_${dirname}"] { source  => $source  }
        } elsif ($content != '' and $source == '') {
            Concat::Fragment["${nfs::params::exportsfile}_${dirname}"] { content => $content }
        } else {
            $allowed_hosts_array = flatten([$allowed_hosts])
            Concat::Fragment["${nfs::params::exportsfile}_${dirname}"] { content => template('nfs/export_entry.erb') }
        }

    }
    if ( (! defined(File[$dirname])) and  ($ensure == 'present')) {
        exec { "mkdir -p ${dirname}":
            path   => [ '/bin', '/usr/bin' ],
            unless => "test -d ${dirname}",
        }
        file { $dirname:
            ensure  => 'directory',
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
            require => Exec["mkdir -p ${dirname}"]
        }
    }

}
