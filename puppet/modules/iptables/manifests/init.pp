class iptables {

  service { 
     iptables:
        enable    => false,   
        ensure    => stopped, 
        hasstatus => false,   
  }

}