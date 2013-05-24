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

==== AWS Vagrant Provider ====
The AWS vagrant provider configuration template is in the Vagrantfile. It has been tested on a Centos 6.4 AMI. Add your AWS information and a Centos 6.4 AMI. Follow these instructions https://github.com/mitchellh/vagrant-aws

The Centos AMI will need to have puppet installed, a vagrant user and a vagrant_data folder before it is provisioned. Run the puppet/manifests/centos_aws.pp manifest and create a AMI. Use this AMI in your Vagrantfile.

Note: The config.vm.synced_folder setting in the Vagrantfile is not supported with the AWS Vagrant provider.

