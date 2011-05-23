class magento {
  
  exec { "create-magentodb-db":
        unless => "/usr/bin/mysql -uroot -p${db_root_password} magentodb",
        command => "/usr/bin/mysql -uroot -p${db_root_password} -e \"create database magentodb;\"",
        require => [Service["mysqld"], Exec["set-mysql-password"]]
  }

  exec { "grant-magentodb-db-all":
        unless => "/usr/bin/mysql -umagento -p${db_magento_password} magentodb",
        command => "/usr/bin/mysql -uroot -p${db_root_password} -e \"grant all on *.* to magento@'%' identified by '${db_magento_password}' WITH GRANT OPTION;\"",
        require => [Service["mysqld"], Exec["create-magentodb-db"]]
  }      
      
  exec { "grant-magentodb-db-localhost":
        unless => "/usr/bin/mysql -umagento -p${db_magento_password} magentodb",
        command => "/usr/bin/mysql -uroot -p${db_root_password} -e \"grant all on *.* to magento@'localhost' identified by '${db_magento_password}' WITH GRANT OPTION;\"",
        require => Exec["grant-magentodb-db-all"]
  }      

  exec { "download-magento":
    cwd => "/tmp",
    command => "/usr/bin/wget http://www.magentocommerce.com/downloads/assets/1.5.1.0/magento-1.5.1.0.tar.gz",
    creates => "/tmp/magento-1.5.1.0.tar.gz"
  }
  
  exec { "untar-magento":
    cwd => $document_root,
    command => "/bin/tar xvzf /tmp/magento-1.5.1.0.tar.gz",
    require => [Exec["download-magento"],  Class["zendserverce"]]
  }
  						
  exec { "setting-permissions":
    cwd => "$document_root/magento",
    command => "/bin/chmod 550 mage; /bin/chmod o+w var var/.htaccess app/etc; /bin/chmod -R o+w media",
    require => Exec["untar-magento"],
  }
  				
   host { 'magento.localhost':
           ip => '127.0.0.1',
   }

  exec { "install-magento":
    cwd => "$document_root/magento",
    creates => "$document_root/magento/app/etc/local.xml",
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
    require => [Exec["setting-permissions"],Exec["create-magentodb-db"]],
  }
  	
}
