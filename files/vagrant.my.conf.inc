server
{
    listen 80;
    server_name vagrant-test.my;

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