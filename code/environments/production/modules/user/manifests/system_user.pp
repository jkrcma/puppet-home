define user::system_user($homedir_path = "/nonexistent", $enable_shell = false) {
    user { $name:
        ensure => present,
        managehome => false,
        home => $homedir_path,
        shell => $enable_shell ? {
            true => '/bin/sh',
            false => '/bin/false',
        },
        password => '*',
        purge_ssh_keys => true,
        require => Group[$name],
    }

    group { $name: }
}
