# File::      init.pp
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2015 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------

class nfs inherits nfs::params {
  contain nfs::server
  contain nfs::client
}

