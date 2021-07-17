define user::user($id = undef, $sudo = false, $sshkey_type = undef, $sshkey = undef) {
    $homedir_path = "/home/$name"

    # create user in the system, password is disabled
    user { $name:
        ensure => present,
        managehome => true,
        home => $homedir_path,
        shell => '/bin/bash',
        uid => $id,
        gid => $name,
        password => '!',
        purge_ssh_keys => true,
        require => Group[$name],
    }

    # create user's private group
    group { $name: gid => $id }

    # create home directory
    file { $homedir_path:
        ensure => directory,
        owner => $name,
        group => $name,
        require => User[$name],
    } ~>
    # copy skeleton if .bashrc is missing (tricky ;)
    exec { "$name-copy-etc-skel":
        path => ['/bin'],
        command => "cp /etc/skel/* $homedir_path && chown $name:$name $homedir_path/*",
        creates => "$homedir_path/.bashrc",
    } ->
    # enforce custom .profile with $TERM hack
    file { "${homedir_path}/.profile":
        ensure => file,
        source => 'puppet:///modules/user/bash_profile',
    }

    # grant passwordless sudo and 'sudo' group - a bit useless but whatever
    if ($sudo) {
        User<| title == $name |> {
            groups => ['sudo']
        }

        file { "/etc/sudoers.d/10_$name-nopasswd":
            ensure => file,
            mode => '0440',
            content => "$name ALL=(ALL) NOPASSWD: ALL"
        }
    }

    # import public SSH key
    if ($sshkey) {
        ssh_authorized_key { "$name@sshkey":
          ensure => present,
          user   => $name,
          type   => $sshkey_type,
          key    => $sshkey,
        }
    }
}
