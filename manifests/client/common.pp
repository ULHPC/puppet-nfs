# ------------------------------------------------------------------------------
# = Class: nfs::client::common
#
# Base class to be inherited by the other nfs::client classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class nfs::client::common {

    # Load the variables used in this module. Check the nfs::client-params.pp file
    require nfs::params

    package { $nfs::params::client_packagename:
        ensure  => $nfs::client::ensure,
    }

}
