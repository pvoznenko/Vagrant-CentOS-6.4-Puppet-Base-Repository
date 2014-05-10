server
{
    listen 80;
    server_name vagrant-test.my;

    # because vagrant inherit bug from virtualbox regarding shared folders
    # in some point it could corrupt files. When you change a file on/in a shared folder, 
    # the change is not seen when through a webserver (e.g. nginx).
    # for more info: https://github.com/mitchellh/vagrant/issues/351#issuecomment-1339640
    # ticket at VB: https://www.virtualbox.org/ticket/9069
    sendfile off;

    access_log /vagrant/shared/logs/vagrant-test.my.access.log;

    error_log /vagrant/shared/logs/vagrant-test.my.error.log;

    root /vagrant/shared/www;

    index index.php index.html index.htm;

    # use fastcgi for all php files
    location ~ \.php$
    {
        fastcgi_pass 127.0.0.1:9001;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
