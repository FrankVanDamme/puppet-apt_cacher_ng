# apt_cacher_ng

#### Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)

## Description

This module installs `apt-cacher-ng` by distribution package. It also creates the
cache directory `/var/cache/apt-cacher-ng` and the apt-cacher-ng user.

What's the value over just using a package resource somewhere? Well, since we
manage the cache directory, it gives you the opportunity to set up your own
logic around using a separate partition for your cached files. 

~~~ puppet
    Mount['/var/cache/apt-cacher-ng']
    ->
    File['/var/cache/apt-cacher-ng'] 
~~~

The File resource is defined in this module, the Mount is the thing you yourself
could define outside this module. This works rather well with the
**puppetlabs-lvm** module (tested v. 0.9.0).

Also, there is a hiera lookup in there for **apt::proxy** since that is an
obvious thing to have in your apt configuration (when running the Puppetlabs
`apt` module at least), in which case, the package is installed *before* the
proxy is configured in apt, which would create an awkward chicken and egg
problem.

## Usage

~~~ puppet
include apt_cacher_ng
~~~

## Reference

One main class, one parameter:
* `passthroughpattern`: (optional) the one configuration parameter in
  apt-cacher-ng everyone seems to need at some point.

## Limitations

Many! This is a really simple module that just creates a directory, a user, and
installs a package with minimal configuration.
