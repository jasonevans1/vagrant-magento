class mysql {

  # mysql
  package { "mysql-server": ensure => installed }
  package { "mysql": ensure => installed }
    
  service { "mysqld":
               enable => true,
               ensure => running,
               require => Package["mysql-server"],
  }
            
	exec { "set-mysql-password":
    		unless => "mysqladmin -uroot -p${db_root_password} status",
    		path => ["/bin", "/usr/bin"],
    		command => "mysqladmin -uroot password ${db_root_password}",
    		require => Service["mysqld"],
  }    
  		       
}
