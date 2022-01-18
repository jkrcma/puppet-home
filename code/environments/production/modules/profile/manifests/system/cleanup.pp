class profile::system::cleanup (String $default_user) {
    exec { "delete ${default_user} user":
        command => "killall -w -u ${default_user}; deluser --remove-all-files ${default_user}",
        onlyif => "id ${default_user}",
        path => ['/usr/sbin', '/usr/bin'],
    }
}
