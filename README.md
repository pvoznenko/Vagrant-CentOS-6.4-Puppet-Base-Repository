Vagrant Puppet Centos-6.4
=========================

Vagrant with CentOS 6.4 x86-64. Puppet setup: php, nginx, xdebug, phpunit, redis, mysql, other (@see manifests/base.pp). 

Sandbox for web-development.

This a base example how to use puppet and vagrant together. 

Puppet manifest is far from been perfect, and I am  not recommend you to configure VM as I did for live servers. 

So use it only as example and on your own risk.

### Setup:

Clone repository:

    $ git clone https://github.com/fosco-maestro/Vagrant-CentOS-6.4-Puppet-Base-Repository

Go to `my_vagrant_folder` and run `vagrant up` command:

    $ cd my_vagrant_folder
    $ vagrant up

Vagrant will download [VM box of CentOS 6.4 x86-64][4] and assign it private network `192.168.33.10` with port on host `8888`.

Config of VM see in file `Vagrantfile`.

After VM run puppet will install manifest from `manifests/base.pp`.

You could access VM through private network ip `192.168.33.10` or through port on your host `127.0.0.1:8888`.  

Nginx on VM will look in folder `shared/www` for `index.php` file.

To access DB from your host machine default configuration are:
- host: `192.168.33.10`
- user: `test_user`
- password: `test_user`

it also creates two databases with names: `test` and `test_test`.

Root password for mysql `root` user is: `root`.

### Required:

You need to install [Vagrant][1] (Vagrant require [VirtualBox][3]).

### Default Configuration:

#### VM (file: `Vagrantfile`)
- config.vm.box = "centos-6.4-x86_64"
- config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130309.box"
- config.vm.network :forwarded_port, guest: 80, host: 8888
- config.vm.network :private_network, ip: "192.168.33.10"
- config.vm.synced_folder "./shared/www", "/www", :mount_options => ["dmode=777,fmode=777"]
- config.vm.synced_folder "./shared/logs", "/logs",  :mount_options => ["dmode=777,fmode=777"]
- config.vm.virtualbox.memory = 1024
- puppet manifest at: `manifests\base.pp`

#### DB (file: `manifests\base.pp`)
- default engine: `InnoDB`
- root password: `root`
- bind address: `0.0.0.0`
- sql mode: ``
- host: `192.168.33.10`
- user: `test_user`
- password: `test_user`
- databases: `test`, `test_test`

#### nginx (file: `manifests\base.pp`)
- file config location: `/etc/nginx/config.d/default.conf`
- listen: `80`
- server name: `vagrant-test.my`
- access log: `/vagrant/shared/logs/vagrant-test.my.access.log`
- error log: `/vagrant/shared/logs/vagrant-test.my.error.log`
- root: `/vagrant/shared/www`

#### FastCGI (file: `manifests\base.pp`)
- `127.0.0.1:9001`

#### Redis (file: `manifests\base.pp`)
- bind on: `0.0.0.0`

#### PHP (file: `manifests\base.pp`)
- display errors: `On`
- display startup errors: `On`
- short open tag: `On`
- error reporting: `E_ALL & ~E_DEPRECATED`
- memory limit: `256M`
- date timezone: `Europe/Berlin`
- error log: `/vagrant/shared/logs/php_error.log`

#### PHP FPM (file: `manifests\base.pp`)
- listen: `127.0.0.1:9001`
- user: `vagrant`
- error log: `/vagrant/shared/logs/phpfpm_error.log`
- slowlog: `/vagrant/shared/logs/phpfpm_slowlog.log`

#### Installed Packages

centos-6.4-x86_64, php54, nginx, phpfpm, mysql, redis, puppet, vim, nc, zip, unzip, git, mlocate, memcached, imagemagick, phpunit-3.7.28.

php modules: 'devel', 'pear', 'mysql', 'mbstring', 'xml', 'gd', 'tidy', 'pecl-memcache', 'pecl-memcached', 'pecl-imagick', 'pecl-redis', 'pecl-xdebug'.


[1]: http://www.vagrantup.com/
[2]: http://docs.puppetlabs.com/guides/installation.html
[3]: https://www.virtualbox.org/
[4]: http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130309.box
