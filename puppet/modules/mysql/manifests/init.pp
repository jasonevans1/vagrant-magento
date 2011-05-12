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
    		unless => "mysqladmin -uroot -pmagento status",
    		path => ["/bin", "/usr/bin"],
    		command => "mysqladmin -uroot password magento",
    		require => Service["mysqld"],
  		 }    
  		 
    exec { "create-magentodb-db":
        unless => "/usr/bin/mysql -uroot -pmagento magentodb",
        command => "/usr/bin/mysql -uroot -pmagento -e \"create database magentodb;\"",
        require => [Service["mysqld"], Exec["set-mysql-password"]]
      }

    exec { "grant-magentodb-db-all":
        unless => "/usr/bin/mysql -umagento -psecret magentodb",
        command => "/usr/bin/mysql -uroot -pmagento -e \"grant all on magentodb.* to magento@'%' identified by 'secret';\"",
        require => [Service["mysqld"], Exec["create-magentodb-db"]]
      }  		 
      
    exec { "grant-magentodb-db-localhost":
        unless => "/usr/bin/mysql -umagento -psecret magentodb",
        command => "/usr/bin/mysql -uroot -pmagento -e \"grant all on magentodb.* to magento@'localhost' identified by 'secret';\"",
        require => Exec["grant-magentodb-db-all"]
      }  		 
      
}
