class profile::account::taiku {
    user::user { 'taiku':
        id => 1000,
        sudo => true,
        sshkey_type => hiera('account::taiku::sshkey_type'),
        sshkey => hiera('account::taiku::sshkey')
    }
}
