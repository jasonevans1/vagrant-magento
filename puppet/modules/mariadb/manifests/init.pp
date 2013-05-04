class mariadb {

  exec { "remove-mysql":
    		path => ["/bin", "/usr/bin"],
    		command => "yum -y -q remove mysql*"
  }    


    yumrepo { "MariaDB":
        descr => "MariaDB",
        baseurl => "http://yum.mariadb.org/5.5/centos6-x86",
        enabled => 1,
        gpgcheck => 0,
        gpgkey => "https://yum.mariadb.org/RPM-GPG-KEY-MariaDB"
    }

  package { "MariaDB-server": ensure => installed, require => [Yumrepo["MariaDB"], Exec["remove-mysql"] ]}
  package { "MariaDB-client": ensure => installed, require => [Yumrepo["MariaDB"], Exec["remove-mysql"] ]}
    
  service { "mysql":
               enable => true,
               ensure => running,
               require => Package["MariaDB-server"],
  }
            
	exec { "set-mysql-password":
    		unless => "mysqladmin -uroot -pmagento status",
    		path => ["/bin", "/usr/bin"],
    		command => "mysqladmin -uroot password magento",
    		require => Service["mysql"],
  }    
  		       
}
