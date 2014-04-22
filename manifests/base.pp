#variables
$db_name = 'test'
$db_name_test = 'test_test'
$db_user = 'test_user'
$db_user_pass = 'test_user'

# Edit local /etc/hosts files to resolve some hostnames used on your application.
host { 'localhost.localdomain':
    ensure => 'present',
    target => '/etc/hosts',
    ip => '127.0.0.1',
    host_aliases => ['localhost', 'vagrant-test.my']
}

# Adding EPEL repo. We'll use later to install Redis class.
class { 'epel': }

# Memcached server (12MB)
class { "memcached": memcached_port => '11211', maxconn => '2048', cachesize => '12' }

# Miscellaneous packages.
package { ['vim-enhanced','nc','zip','unzip','git', 'mlocate']: ensure => latest }

# update locate db
exec { '/usr/bin/updatedb': require => Package['mlocate'] }

#switch off iptables
service { 'iptables':
  ensure => 'stopped',  enable => 'false',
}

# MySQL packages and some configuration to automatically create a new database.
class { 'mysql': }

# PhpMyAdmin
class { 'phpmyadmin': }

# Imagick
class { 'imagemagick': }

# MySQL
class { 'mysql::server':
    config_hash => {
        default_engine  => 'InnoDB',
        root_password    => 'root',
        bind_address => '0.0.0.0',
        sql_mode => ''
    },
}

Database {
    require => Class['mysql::server'],
}

database { [$db_name, $db_name_test]:
    ensure => 'present',
    charset => 'utf8',
    require => [ Package['mysql'], Class['mysql::config']]
}

database_user { "${db_user}@%":
    password_hash => mysql_password($db_user_pass),
    require => [ Package['mysql'], Class['mysql::server'], Class['mysql::config']]
}

database_grant { "${db_user}@%/${db_name}":
    privileges => ['all'],
    require => [ Package['mysql'], Class['mysql::server'], Database_user["${db_user}@%"], Database[$db_name] ]
}

database_grant { "${db_user}@%/${db_name_test}":
    privileges => ['all'],
    require => [ Package['mysql'], Class['mysql::server'], Database_user["${db_user}@%"], Database[$db_name_test] ]
}

package { [ "mysql-devel", "mysql-libs" ]: ensure => present }

# nginx
include nginx

nginx::file { 'default.conf':
    source => '/vagrant/files/vagrant.my.conf.inc',
}

# Redis installation.
class redis {
    package { "redis":
        ensure => 'latest',
       require => Yumrepo['epel'],
    }
    service { "redis":
        enable => true,
        ensure => running,
    }
    file { "/etc/redis.conf":
      ensure => present,
      content => template("/vagrant/files/redis.conf"),
      notify => Service["redis"]
    }
}

include redis

# PHP useful packages
php::ini {
    '/etc/php.ini':
        display_errors  => 'On',
        display_startup_errors => 'On',
        short_open_tag  => 'On',
        error_reporting => 'E_ALL & ~E_DEPRECATED',
        memory_limit    => '256M',
        date_timezone   => 'Europe/Berlin',
        error_log => '/vagrant/shared/logs/php_error.log'
}

include php::cli
include php::fpm::daemon

php::fpm::conf { 'www':
    listen  => '127.0.0.1:9001',
    user    => 'vagrant',
    error_log => '/vagrant/shared/logs/phpfpm_error.log',
    slowlog => '/vagrant/shared/logs/phpfpm_slowlog.log',
    # For the user to exist
    require => Package['nginx'],
}

php::module { [ 'devel', 'pear', 'mysql', 'mbstring', 'xml', 'gd', 'tidy', 'pecl-memcache', 'pecl-memcached', 'pecl-imagick', 'pecl-redis', 'pecl-xdebug']:
    require => [ Package['redis'], Package['mysql'], Package['memcached'] ]
}

# PHPUnit
exec { '/usr/bin/pear upgrade pear':
    require => Package['php-pear'],
    timeout => 0
}

define discoverPearChannel {
    exec { "/usr/bin/pear channel-discover $name":
        onlyif => "/usr/bin/pear channel-info $name | grep \"Unknown channel\"",
        require => Exec['/usr/bin/pear upgrade pear'],
        timeout => 0
    }
}
discoverPearChannel { 'pear.phpunit.de': }
discoverPearChannel { 'pear.symfony-project.com': }
discoverPearChannel { 'pear.symfony.com': }

exec { '/usr/bin/pear install --alldeps pear.phpunit.de/PHPUnit-3.7.28':
    onlyif => "/usr/bin/pear info phpunit/PHPUnit-3.7.28 | grep \"No information found\"",
    require => [
        Exec['/usr/bin/pear upgrade pear'],
        DiscoverPearChannel['pear.phpunit.de'],
        DiscoverPearChannel['pear.symfony-project.com'],
        DiscoverPearChannel['pear.symfony.com']
    ],
    user => 'root',
    timeout => 0
}