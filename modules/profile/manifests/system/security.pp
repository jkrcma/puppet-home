class profile::system::security (Array $rules = []) {
    file { '/etc/security/access.conf':
        ensure => file,
        content => template('profile/security/access.conf.erb'),
    }

    ['login', 'sshd'].each |String $file| {
        file_line { "enable pam_access in ${file}":
            path => "/etc/pam.d/${file}",
            line => 'account    required   pam_access.so',
            match => '^# account\\s+required\\s+pam_access.so',
            append_on_no_match => false,
        }
    }
}
