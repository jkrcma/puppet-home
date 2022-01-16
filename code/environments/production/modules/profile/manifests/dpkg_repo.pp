class profile::dpkg_repo {
    package { 'dpkg-dev':
        ensure => latest,
    }

    file { '/usr/local/bin/refresh-repo.sh':
        ensure => file,
        mode => '0755',
        source => 'puppet:///modules/profile/dpkg_repo/refresh-repo.sh',
    }

    file { ['/srv/packages', '/srv/packages/xenial']:
        ensure => directory,
        owner => repository,
        group => repository,
        require => User['repository'],
    }

    file { '/srv/packages/xenial/release-meta':
        ensure => file,
        source => 'puppet:///modules/profile/dpkg_repo/release-meta.xenial',
        owner => repository,
        group => repository,
    }

    user::system_user { 'repository':
        homedir_path => '/srv/packages',
        enable_shell => true,
    }

    include nginx
    nginx::virtualhost { 'default':
        source => 'puppet:///modules/profile/dpkg_repo/default.nginx',
    }
}
