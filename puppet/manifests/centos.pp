
class centos {							
  $document_root = '/vagrant_data'    
  
  package {'wget':
    ensure => latest 
  }
  
  include zendserverce
  include mariadb
  include magento
  include phpunit
  include iptables

}

include centos
