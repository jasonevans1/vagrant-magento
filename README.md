Provides a foundation for developing with Magento Commerce in a Vagrant box. The machine is based on CentOS 6.4. 

==== List of installed software.
* Magento Community Edition - 1.7.0.2
* MariaDB 5.5
* Zend Server 6.0.1 - PHP 5.4
* phpunit

==== The settings used to install Magento are in the file:  puppet/modules/magento/manifests/init.php.
* Magento admin user: admin
* Magento admin password: secret123
* Database username: magento
* Database password: secret

==== Vagrant Information ====
The Vagrantfile has been setup to use Vagrant 1.2.2. It is setup with bridged networking and forwarding ports 80, 10081 and 3306.

==== Zend Server 6 Information ====
You will need to optain a free license key from zend.com otherwise the enterprise trial will expire.  

[Ruby](http://ruby-lang.org) and [Vagrant](http://vagrantup.com) and VirtualBox are prerequisites. 