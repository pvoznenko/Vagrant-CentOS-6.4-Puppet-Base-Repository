upstream wwwbackend {
    server 127.0.0.1:9001;
}

server {
    listen       80 default_server;
    server_name  _;

    charset UTF-8;

    #access_log  logs/host.access.log  main;

    location / {
        root   /www;
        index  index.php index.html;
    }

    location ~ \.php$ {
        if (!-f $request_filename) { return 404; }
        include /etc/nginx/fastcgi.conf;
        fastcgi_pass wwwbackend;
    }
}
