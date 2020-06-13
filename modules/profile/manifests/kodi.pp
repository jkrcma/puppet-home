class profile::kodi {
    apt::ppa { 'team-xbmc':
        source => 'puppet:///modules/profile/kodi/sources.list'
        fingerprint => '91E7EE5E',
    } ->
    package { 'kodi':
        ensure => latest,
    }

    user::user { 'kodi':
        id => 55555,
    } ->
    User<| title == 'kodi' |> {
        groups => ['audio', 'video', 'input'],
    }

    file { '/home/kodi/.xinitrc':
        ensure => file,
        owner => kodi,
        group => kodi,
        content => "kodi --standalone\n",
        require => User['kodi'],
    }
}
