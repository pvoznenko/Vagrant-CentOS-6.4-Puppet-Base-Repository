vagrant-puppet-centos-6.4
=========================

Vagrant with CentOS 6.4 x86-64. Puppet setup: php, nginx, xdebug, phpunit, redis, mysql, other (@see manifests/base.pp). 
Sandbox for web-development.

This a base example how to use puppet and vagrant together. 
Puppet manifest is far from been perfect, and I am  not recommend you to configure VM as I did for live servers. 
So use it only as example and on your own risk.

### Setup:

Clone repository:

    $ git clone https://github.com/fosco-maestro/Vagrant-CentOS-6.4-Puppet-Base-Repository--php--nginx--xdebug--phpunit--redis--mysql-.git {dest folder}

Go to {dest folder} and run `vagrant up` command:

    $ cd {dest folder}
    $ vagrant up

Vagrant will download [VM box of CentOS 6.4 x86-64][4] and assign it private network `192.168.33.10` with port on host `8888`.
Config of VM see in file `Vagrant`.
After VM run puppet will install manifest from `manifests/base.pp`.

You could access or VM nginx through private network ip `192.168.33.10` or through port on your host `127.0.0.1:8888`.  

### Required:

You need to have [Vagrant][1] (Vagrant require [VirtualBox][3]) and [Puppet][2] been installed.

[1]: http://www.vagrantup.com/
[2]: http://docs.puppetlabs.com/guides/installation.html
[3]: https://www.virtualbox.org/
[4]: http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130309.box
