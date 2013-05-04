
class phpunit {
 exec { "pear-channel-discover-phpunit":
    command => "/usr/local/zend/bin/pear channel-discover pear.phpunit.de",
    creates => "/usr/local/zend/bin/phpunit",
    require => Class["zendserverce"]
  }

  exec { "pear-channel-discover-components":
    command => "/usr/local/zend/bin/pear channel-discover components.ez.no",
    creates => "/usr/local/zend/bin/phpunit",
    require => Class["zendserverce"]
  }

  exec { "pear-channel-discover-symfony-project":
    command => "/usr/local/zend/bin/pear channel-discover pear.symfony-project.com",
    creates => "/usr/local/zend/bin/phpunit",
    require => Class["zendserverce"]
  }

  exec { "pear-channel-discover-symfony2":
    command => "/usr/local/zend/bin/pear channel-discover pear.symfony.com",
    creates => "/usr/local/zend/bin/phpunit",
    require => Class["zendserverce"]
  }

  exec { "upgrade-pear":
    command => "/usr/local/zend/bin/pear upgrade",
    creates => "/usr/local/zend/bin/phpunit",
    require => Class["zendserverce"]
  }

  exec { "pear-install-phpunit":
    command => "/usr/local/zend/bin/pear install phpunit/PHPUnit",
    creates => "/usr/local/zend/bin/phpunit",
    require => [Exec["upgrade-pear"],Exec["pear-channel-discover-phpunit"], Exec["pear-channel-discover-components"], Exec["pear-channel-discover-symfony-project"], Exec["pear-channel-discover-symfony2"]]
  } 
}
