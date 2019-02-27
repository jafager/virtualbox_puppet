class virtualbox_host_genesis
{

    ###
    ### DHCP
    ###

    package { 'dhcp':
        ensure => present,
    }

    file { '/etc/dhcp/dhcpd.conf':
        ensure => present,
        owner => root,
        group => root,
        mode => '0644',
        source => 'puppet:///modules/virtualbox_host_genesis/etc_dhcp_dhcpd_conf',
        require => Package['dhcp'],
    }

    service { 'dhcpd':
        ensure => running,
        enable => true,
        subscribe => File['/etc/dhcp/dhcpd.conf'],
    }

}
