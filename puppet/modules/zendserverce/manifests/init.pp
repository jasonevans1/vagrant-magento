
class zendserverce {
  exec{set_selinux_disabled:
        command => '/usr/sbin/setenforce permissive',    
        onlyif => '/usr/sbin/getenforce | grep Enforcing';               
  }
    
  file { "/etc/selinux/config":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => "0644",
      source  => "puppet:///modules/zendserverce/selinux",
  }    
  
  file { "/etc/rc.local":
      ensure  => present,
      owner   => "root",
      group   => "root",
      mode    => "0777",
      source  => "puppet:///modules/zendserverce/rc.local",
  }    
    
    # 1.) Make sure Zend yum repos are installed 

    yumrepo { "Zend":
        descr => "Zend Server",
        baseurl => "http://repos.zend.com/zend-server/rpm/\$basearch",
        enabled => 1,
        gpgcheck => 0,
        gpgkey => "http://repos.zend.com/zend.key"
    }
    yumrepo { "Zend_noarch":
        descr => "Zend Server - noarch",
        baseurl => "http://repos.zend.com/zend-server/rpm/noarch",
        enabled => 1,
        gpgcheck => 0,
        gpgkey => "http://repos.zend.com/zend.key"
    }

    # 2.) Install Zend Server dependencies

    package { "httpd-devel":
        ensure => installed
    }

    # 3.) Install Zend Server CE

    package { "zendserverce":
        name => "zend-server-ce-php-5.3",
        ensure => installed,
        require => [ 
			      Exec["set_selinux_disabled"],
            Yumrepo["Zend"], 
            Yumrepo["Zend_noarch"], 
            Package["httpd-devel"]
        ]
    }
			
    # fix admin panel bug where
    # logs arent readable by default
    file { "/var/log/httpd":
        mode => 755,
        require => Package["zendserverce"]
    }
    service { "httpd":
        ensure => running,
	      subscribe => File["/etc/httpd/conf/httpd.conf"],        
        require => Package["zendserverce"]
    }
    
    file { "/etc/httpd/conf/httpd.conf":
        ensure  => present,
        owner   => "root",
        group   => "root",
        mode    => "0644",
        source  => "puppet:///modules/zendserverce/httpd.conf",
        require => Package["zendserverce"];
    }
    
    exec { "start-zendserverce":
      command => "/usr/local/zend/bin/zendctl.sh restart",
      require => [Package["zendserverce"],Exec["set_selinux_disabled"]];
    }
    
}
