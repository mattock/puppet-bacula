#
# == Class: bacula::director::config::postgresql
#
# Configure the Bacula database on postgresql server. Currently only supports 
# Debian (and possibly Ubuntu).
#
class bacula::director::config::postgresql
(
    $postgresql_auth_line,
    $bacula_db_password
)
{

    # Prepare postgresql for Bacula's own database schema scripts
    postgresql::loadsql { 'bacula-bacula-director.sql':
        modulename => 'bacula',
        basename => 'bacula-director',
    }

    # FIXME: neither of the two following Execs seem to get run during initial 
    # install. The reason could be the "refreshonly" parameter: the first Puppet 
    # run almost never works, and if the Execs are loaded then, they will not be 
    # loaded again later, when they could actually do some good. At this point 
    # this is just pure speculation, but the problem itself has been encountered 
    # on every Bacula install so far.
    exec { 'bacula-make_postgresql_tables':
        environment => [ 'db_name=bacula' ],
        command => '/usr/share/bacula-director/make_postgresql_tables',
        cwd => '/tmp',
        path => [ '/usr/bin' ],
        user => 'postgres',
        refreshonly => true,
        require => Postgresql::Loadsql['bacula-bacula-director.sql'],
    }

    exec { 'bacula-grant_postgresql_privileges':
        environment => [ 'db_name=bacula', 'db_user=baculauser' ],
        command => '/usr/share/bacula-director/grant_postgresql_privileges',
        cwd => '/tmp',
        path => [ '/usr/bin' ],
        user => 'postgres',
        refreshonly => true,
        require => Exec['bacula-make_postgresql_tables'],
    }

    # Add an authentication line for baculauser to postgresql pg_hba.conf. For 
    # details look into postgresql::config class.
    augeas { 'bacula-director-pg_hba.conf':
        context => '/files/etc/postgresql/9.3/main/pg_hba.conf',
        changes => [
            "ins 0434 after 1",
            "set 0434/type local",
            "set 0434/database bacula",
            "set 0434/user baculauser",
            "set 0434/method password"
        ],
        lens => 'Pg_hba.lns',
        incl => '/etc/postgresql/9.3/main/pg_hba.conf',
        # Without "onlyif" every Puppet run would generate a new authentication 
        # line to pg_hba.conf.
        onlyif => "match *[user = 'baculauser'] size == 0",
    }
}
