# Bacula

A puppet module to manage Bacula Directors, Storagedaemons and Filedaemons

# Module usage

The Puppet manifests written for Vagrant show how to use the module:

* [All daemons+console](vagrant/all.pp)
* [Filedaemon only](vagrant/fd.pp)

For further details refer to module entrypoints:

* [Class: bacula::director](manifests/director.pp)
* [Class: bacula::storagedaemon](manifests/storagedaemon.pp)
* [Class: bacula::filedaemon](manifests/filedaemon.pp)
* [Class: bacula::console](manifests/console.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Debian 7
* Ubuntu 12.04
* Ubuntu 14.04
* Ubuntu 16.04
* CentOS 7
* FreeBSD 10

