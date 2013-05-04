
class centos {							
  $document_root = '/vagrant_data'    
  
  include zendserverce
  include mariadb
  include magento
  include phpunit
  include iptables

}

include centos
