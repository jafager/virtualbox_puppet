node default
{
    class { 'virtualbox_administrators': }
}

node genesis.jafager.vbox
{
    class { 'virtualbox_administrators': }
    class { 'virtualbox_host_genesis': }
}
