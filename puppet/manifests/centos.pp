
class centos {							
  $document_root = '/vagrant_data'    

  $db_root_password = "magento"
  $db_magento_password = "secret"
  
  include zendserverce
  include mysql
  include magento
  include xdebug
  include phpunit

}

include centos
