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

    ###
    ### TFTP
    ###

    package { 'xinetd':
        ensure => present,
    }

    package { 'tftp-server':
        ensure => present,
        require => Package['xinetd'],
    }

    file { '/etc/xinetd.d/tftp':
        ensure => present,
        owner => root,
        group => root,
        mode => '0644',
        source => 'puppet:///modules/virtualbox_host_genesis/etc_xinetd_d_tftp',
        require => Package['tftp-server'],
    }

    service { 'xinetd':
        ensure => running,
        enable => true,
        subscribe => File['/etc/xinetd.d/tftp'],
    }

    exec { 'add tftp service to firewalld':
        command => 'firewall-cmd --permanent --add-service=tftp; firewall-cmd --reload',
        unless => 'firewall-cmd --list-services | egrep \'(^| )tftp( |$)\'',
        refreshonly => true,
    }

}
