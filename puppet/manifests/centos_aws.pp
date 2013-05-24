class centos_aws {							
  
  user { 'vagrant':
    ensure            =>  'present',
    uid               =>  '777',
    gid               =>  'vagrant',
    shell             =>  '/bin/bash',
    home              =>  "/home/vagrant",
    password          =>  'vagrant',
    managehome        =>  true,
    require           =>  Group[vagrant],
  }
 
  group { "vagrant":
    ensure => "present",
  }
 
  file { "/home/vagrant":
    ensure            =>  directory,
    owner             =>  'vagrant',
    group             =>  'vagrant',
    mode              =>  0750,
    require           =>  [ User[vagrant], Group[vagrant] ],
  }
	
	file { "/vagrant_data":
	    ensure => "directory",
	    owner  => "vagrant",
	    group  => "vagrant",
	    mode   => 777,
	    require =>  [ User[vagrant], Group[vagrant] ],
	}
		
}

include centos_aws
	