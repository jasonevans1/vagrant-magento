class magento {
  
  exec { "create-magentodb-db":
        unless => "/usr/bin/mysql -uroot -pmagento magentodb",
        command => "/usr/bin/mysql -uroot -pmagento -e \"create database magentodb;\"",
        require => [Service["mysql"], Exec["set-mysql-password"]]
  }      

  exec { "grant-magentodb-db-all":
        unless => "/usr/bin/mysql -umagento -psecret magentodb",
        command => "/usr/bin/mysql -uroot -pmagento -e \"grant all on *.* to magento@'%' identified by 'secret' WITH GRANT OPTION;\"",
        require => [Service["mysql"], Exec["create-magentodb-db"]]
  }      
      
  exec { "grant-magentodb-db-localhost":
        unless => "/usr/bin/mysql -umagento -psecret magentodb",
        command => "/usr/bin/mysql -uroot -pmagento -e \"grant all on *.* to magento@'localhost' identified by 'secret' WITH GRANT OPTION;\"",
        require => Exec["grant-magentodb-db-all"]
  }      

  exec { "download-magento":
    cwd => "/tmp",
    command => "/usr/bin/wget http://www.magentocommerce.com/downloads/assets/1.8.0.0/magento-1.8.0.0.tar.gz",
    creates => "/tmp/magento-1.8.0.0.tar.gz"
  }
  
  exec { "untar-magento":
    cwd => "/tmp",
    command => "/bin/tar xvzf /tmp/magento-1.8.0.0.tar.gz",
    creates => "/tmp/magento/app/etc/local.xml",
    require => [Exec["download-magento"],  Class["zendserverce"]]
  }

  exec { "setting-permissions":
    cwd => "/tmp/magento",
    command => "/bin/chown -R vagrant /tmp/magento;/bin/chgrp -R vagrant /tmp/magento;/bin/chmod -R 777 /tmp/magento",
    require => Exec["untar-magento"],
  }

  file { "/vagrant_data":
    ensure => directory,
    owner  => "vagrant",
    group  => "vagrant",
    mode   => 775,
  }

  exec { "copy-magento-to-data-folder":
    cwd => "/tmp",
    command => "/bin/cp -r /tmp/magento /vagrant_data/",
    creates => "/vagrant_data/magento/app/etc/local.xml",    
    require => [Exec["setting-permissions"], File["/vagrant_data"]]
  }

  exec { "copy-hidden-files-magento-to-data-folder":
    cwd => "/tmp",
    command => "/bin/cp -r /tmp/magento/.[a-zA-Z0-9]* /vagrant_data",
    creates => "/vagrant_data/magento/.htaccess",    
    require => [Exec["copy-magento-to-data-folder"]]
  }

  				
   host { 'magento.localhost':
           ip => '127.0.0.1',
   }

  exec { "install-magento":
    cwd => "/vagrant_data/magento",
    creates => "/vagrant_data/magento/app/etc/local.xml",
    command => '/usr/local/zend/bin/php-cli -f install.php -- \
    --license_agreement_accepted "yes" \
    --locale "en_US" \
    --timezone "America/Los_Angeles" \
    --default_currency "USD" \
    --db_host "localhost" \
    --db_name "magentodb" \
    --db_user "magento" \
    --db_pass "secret" \
    --url "http://magento.localhost:8080/magento" \
    --use_rewrites "yes" \
    --use_secure "no" \
    --secure_base_url "http://magento.localhost:8080/magento" \
    --use_secure_admin "no" \
    --skip_url_validation "yes" \
    --admin_firstname "Store" \
    --admin_lastname "Owner" \
    --admin_email "email@address.com" \
    --admin_username "admin" \
    --admin_password "secret123"',
    require => [Exec["copy-hidden-files-magento-to-data-folder"],Exec["create-magentodb-db"],Exec["grant-magentodb-db-localhost"]],
  }
  	
}
