
class xdebug {
  # /usr/local/zend/bin/pecl install xdebug
  # mv /usr/local/zend/share/pear/.channels /usr/local/zend/share/pear/.channels_old
  # /usr/local/zend/bin/pear channel-update pear.php.net
  exec { "pear-channel-update":
    command => "/usr/local/zend/bin/pear channel-update pear.php.net",
    require => Class["zendserverce"]
  }


  # /usr/local/zend/bin/pecl install xdebug
  exec { "pecl-install-xdebug":
    command => "/usr/local/zend/bin/pecl install xdebug",
    creates => "/usr/local/zend/lib/php_extensions/xdebug.so",
    require => Exec["pear-channel-update"]
  }

    file { "/usr/local/zend/etc/php.ini":
        ensure  => present,
        owner   => "root",
        group   => "root",
        mode    => "0644",
        source  => "puppet:///modules/xdebug/php.ini",
        require => Exec["pecl-install-xdebug"]
    } 
 
    exec { "restart-zendserverce":
      command => "/usr/local/zend/bin/zendctl.sh restart",
      require => File["/usr/local/zend/etc/php.ini"]
	}
 
}
