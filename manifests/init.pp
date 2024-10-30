class apt_cacher_ng (
    $passthroughpattern = '',
    $package_ensure = present,
) {

    # pre-install user and file in case you want to put the data directory on a
    # separate partition.
    user { "apt-cacher-ng":
        system => true,
        ensure => present,
    }
    ->
    file { '/var/cache/apt-cacher-ng':
        ensure  => 'directory',
        owner   => 'apt-cacher-ng',
        group   => 'apt-cacher-ng',
        mode    => '2755',
    }
    ->
    package { "apt-cacher-ng":
        ensure  => $package_ensure,
        require => File['/var/cache/apt-cacher-ng'],
    }
    ->
    file { "/etc/apt-cacher-ng/acng.conf":
        content => template("${module_name}/acng.conf.erb"),
        mode    => '644',
    }
    ~>
    service { "apt-cacher-ng":
        ensure => running,
        enable => true,
    }
}
