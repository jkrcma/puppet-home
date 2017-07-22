define nginx::virtualhost($source = undef, $content = undef) {
    $vh_filename = "/etc/nginx/sites-available/$name"

    file { $vh_filename:
        source => $source,
        content => $content,
        notify => Exec['enable-nginx-site'],
    }

    exec { 'enable-nginx-site':
        command => "/bin/ln -s $vh_filename /etc/nginx/sites-enabled/$name || /bin/true",
        refreshonly => true,
        notify => Service['nginx'],
    }
}
