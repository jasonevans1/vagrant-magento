Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "centos55"

  config.vm.customize do |vm|
    vm.memory_size = 1024
  end
  
  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host only network IP, allowing you to access it
  # via the IP.
  # config.vm.network "33.33.33.10"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
   config.vm.forward_port "web_front", 80, 8080
   config.vm.forward_port "zend_admin", 10081, 8081
   config.vm.forward_port "mysql", 3306, 3309
   
  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"
  config.vm.share_folder "document-root", "/vagrant_data/magento", "../magento"

  
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppetmanifests"
    puppet.manifest_file = "init.pp"       
    puppet.module_path = "my_modules"
   #puppet.options = "--verbose --debug"
  end  
      
end
