class virtualbox_host_genesis
{

    ###
    ### DHCP
    ###

    package { 'dhcp':
        ensure => present,
    }

}
