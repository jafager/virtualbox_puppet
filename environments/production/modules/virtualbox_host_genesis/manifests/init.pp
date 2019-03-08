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
        path => '/usr/bin',
        unless => 'firewall-cmd --list-services | egrep \'(^| )tftp( |$)\'',
    }

    ###
    ### PXE
    ###

    package { 'syslinux-tftpboot':
        ensure => present,
    }

    file { '/var/lib/tftpboot/pxelinux.cfg':
        ensure => directory,
        owner => root,
        group => root,
        mode => '0755',
        require => Package['syslinux-tftpboot'],
    }

    file { '/var/lib/tftpboot/pxelinux.cfg/default':
        ensure => present,
        owner => root,
        group => root,
        mode => '0644',
        source => 'puppet:///modules/virtualbox_host_genesis/var_lib_tftpboot_pxelinux_cfg_default',
        require => File['/var/lib/tftpboot/pxelinux.cfg'],
    }

    file { '/var/lib/tftpboot/centos7_vmlinuz':
        ensure => present,
        owner => root,
        group => root,
        mode => '0644',
        source => 'puppet:///modules/virtualbox_host_genesis/var_lib_tftpboot_centos7_vmlinuz',
        require => File['/var/lib/tftpboot/pxelinux.cfg'],
    }

    file { '/var/lib/tftpboot/centos7_initrd_img':
        ensure => present,
        owner => root,
        group => root,
        mode => '0644',
        source => 'puppet:///modules/virtualbox_host_genesis/var_lib_tftpboot_centos7_initrd_img',
        require => File['/var/lib/tftpboot/pxelinux.cfg'],
    }

    ###
    ### HTTP
    ###

    package { 'httpd':
        ensure => present,
    }

    service { 'httpd':
        ensure => running,
        enable => true,
        require => Package['httpd'],
    }

    exec { 'add http service to firewalld':
        command => 'firewall-cmd --permanent --add-service=http; firewall-cmd --reload',
        path => '/usr/bin',
        unless => 'firewall-cmd --list-services | egrep \'(^| )http( |$)\'',
    }

    file { '/var/www/html/centos7':
        ensure => directory,
        owner => root,
        group => root,
        mode => '0755',
        source => 'puppet:///modules/virtualbox_host_genesis/var_www_html_centos7',
        recurse => true,
        require => Package['httpd'],
    }

    file { '/var/www/html/centos7/LiveOS/squashfs.img':
        ensure => present,
        owner => root,
        group => root,
        mode => '0644',
        source => 'http://mirror.centos.org/centos-7/7/os/x86_64/LiveOS/squashfs.img',
        require => File['/var/www/html/centos7'],
    }

    file { '/var/www/html/centos7.ks':
        ensure => present,
        owner => root,
        group => root,
        mode => '0644',
        source => 'puppet:///modules/virtualbox_host_genesis/var_www_html_centos7_ks',
        require => Package['httpd'],
    }

}
