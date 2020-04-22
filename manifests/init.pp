class apt_cacher_ng (
    $passthroughpattern = $apt_cacher_ng::params::passthroughpattern,
) inherits apt_cacher_ng::params {

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

    # to play nice with puppetlabs-apt:
    $aptproxy = hiera('apt::proxy', undef)
    if is_hash ( $aptproxy ){
      if ( $aptproxy['ensure'] == present ){
        Package['apt-cacher-ng'] {
          # conf-proxy wordt aangemaakt binnen apt module (hard coded
          # naam)
          before => Apt::Setting['conf-proxy'],
        }
      }
    }
}
