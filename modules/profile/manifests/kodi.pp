class profile::kodi {
    apt::ppa { 'team-xbmc':
        source => 'puppet:///modules/profile/kodi/sources.list',
        fingerprint => '91E7EE5E',
    } ->
    package { ['kodi', 'xinit']:
        ensure => latest,
    }

    user::user { 'kodi':
        id => 55555,
    }

    User<| title == 'kodi' |> {
        groups => ['audio', 'video', 'input'],
    }

    service { 'x11-kodi':
        enable => true,
        ensure => running,
        require => Package['kodi'],
    }

    file { '/home/kodi/.xinitrc':
        ensure => file,
        owner => kodi,
        group => kodi,
        content => "MESA_LOADER_DRIVER_OVERRIDE=i965 kodi --standalone\n",
        require => User['kodi'],
    }

    file { '/etc/systemd/system/x11-kodi.service':
        ensure => file,
        source => 'puppet:///modules/profile/kodi/x11-kodi.service',
        require => File['/home/kodi/.xinitrc'],
        notify => Service['x11-kodi'],
    }

#    file { '/etc/X11/Xwrapper.config':
#        ensure => file,
#        content => "allowed_users=console\nneeds_root_rights=yes",
#    }

    file { '/etc/X11/xorg.conf.d':
        ensure => directory,
        recurse => true,
        source => 'puppet:///modules/profile/kodi/xorg.conf.d',
        before => Service['x11-kodi'],
    }
}
