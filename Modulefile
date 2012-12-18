name    'nfs'
version '0.0.2'
source  'git-admin.uni.lu:puppet-repo.git'
author  'Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)'
license 'GPL v3'
summary      'Configure and manage NFS (client and/or server)'
description  'Configure and manage NFS (client and/or server)'
project_page 'UNKNOWN'

## List of the classes defined in this module
classes     'nfs::server, nfs::server::common, nfs::server::debian, nfs::server::redhat, nfs::client, nfs::client::common, nfs::client::debian, nfs::client::redhat, nfs::params'
## List of the definitions defined in this module
definitions 'concat, sysctl'

## Add dependencies, if any:
# dependency 'username/name', '>= 1.2.0'
dependency 'concat' 
dependency 'sysctl' 
