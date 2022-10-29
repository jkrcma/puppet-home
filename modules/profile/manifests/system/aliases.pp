class profile::system::aliases ($root_email) {
    file_line { 'root email alias':
        path => '/etc/aliases',
        line => "root: ${root_email}",
        match => '^root: ',
        append_on_no_match => true,
        notify => Exec['update aliases'],
    }

    exec { 'update aliases':
        command => 'newaliases',
        path => ['/usr/bin'],
        refreshonly => true,
    }
}
