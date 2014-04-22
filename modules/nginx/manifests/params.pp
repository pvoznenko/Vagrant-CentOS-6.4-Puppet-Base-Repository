# Class: nginx::params
#
# Parameters for and from the nginx module.
#
# Parameters :
#  none
#
# Sample Usage :
#  include nginx::params
#
class nginx::params {
    # The easy bunch
    $service = 'nginx'
    $user    = 'vagrant'
    $confdir = '/etc/nginx'
    # package
    case $::operatingsystem {
        'Gentoo': { $package = 'www-servers/nginx' }
         default: { $package = 'nginx' }
    }
    # service restart
    case $::operatingsystem {
        'Fedora',
        'RedHat',
        'CentOS': { $service_restart = '/sbin/service nginx reload' }
         default: { $service_restart = '/etc/init.d/nginx reload' }
    }
    # remove_default_conf
    case $::operatingsystem {
        'Fedora',
        'RedHat',
        'CentOS': { $remove_default_conf = false }
         default: { $remove_default_conf = false }
    }
}

