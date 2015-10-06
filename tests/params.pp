# File::      <tt>params.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2015 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'nfs::params'

$names = ['ensure', 'nb_servers', 'optimization', 'client_packagename', 'server_packagename', 'servicename', 'processname', 'hasstatus', 'hasrestart', 'exportsfile', 'exportsfile_mode', 'exportsfile_owner', 'exportsfile_group', 'initconfigfile', 'tuningfile', 'tuningfile_mode', 'tuningfile_owner', 'tuningfile_group']

notice("nfs::params::ensure = ${nfs::params::ensure}")
notice("nfs::params::nb_servers = ${nfs::params::nb_servers}")
notice("nfs::params::optimization = ${nfs::params::optimization}")
notice("nfs::params::client_packagename = ${nfs::params::client_packagename}")
notice("nfs::params::server_packagename = ${nfs::params::server_packagename}")
notice("nfs::params::servicename = ${nfs::params::servicename}")
notice("nfs::params::processname = ${nfs::params::processname}")
notice("nfs::params::hasstatus = ${nfs::params::hasstatus}")
notice("nfs::params::hasrestart = ${nfs::params::hasrestart}")
notice("nfs::params::exportsfile = ${nfs::params::exportsfile}")
notice("nfs::params::exportsfile_mode = ${nfs::params::exportsfile_mode}")
notice("nfs::params::exportsfile_owner = ${nfs::params::exportsfile_owner}")
notice("nfs::params::exportsfile_group = ${nfs::params::exportsfile_group}")
notice("nfs::params::initconfigfile = ${nfs::params::initconfigfile}")
notice("nfs::params::tuningfile = ${nfs::params::tuningfile}")
notice("nfs::params::tuningfile_mode = ${nfs::params::tuningfile_mode}")
notice("nfs::params::tuningfile_owner = ${nfs::params::tuningfile_owner}")
notice("nfs::params::tuningfile_group = ${nfs::params::tuningfile_group}")

#each($names) |$v| {
#    $var = "nfs::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
