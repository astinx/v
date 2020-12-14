#!/bin/bash
BasePath=$(dirname $(readlink -f $0))
cd $BasePath

git fetch --all && git reset --hard origin/dev

chattr -i $BasePath/.user.ini
chmod 777 -R $BasePath && chown -R www:www $BasePath


CurrentDir=`pwd`
CurrentDir=${CurrentDir##*/}
DB_NAME=${CurrentDir//./_}

DB_PSW=`cat $BasePath/../$DB_NAME`

sed -i "s/maccms10/$DB_NAME/g" $BasePath/application/database.php

sed -i "s/root/$DB_NAME/g" $BasePath/application/database.php

sed -i "s/4rfv(IJN/$DB_PSW/g" $BasePath/application/database.php

echo 'location / {
    if (!-e $request_filename) {
        rewrite ^/index.php(.*)$ /index.php?s=$1 last;
        rewrite ^/admin.php(.*)$ /admin.php?s=$1 last;
        rewrite ^/api.php(.*)$ /api.php?s=$1 last;
        rewrite ^(.*)$ /index.php?s=$1 last;
        break;
    }
}' > /www/server/panel/vhost/rewrite/$CurrentDir.conf


`/etc/init.d/nginx reload`