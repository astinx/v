#!/bin/bash
BasePath=$(dirname $(readlink -f $0))
cd $BasePath

git fetch --all && git reset --hard origin/dev

chmod 777 -R $BasePath && chown -R www:www $BasePath

CurrentDir=`pwd`
CurrentDir=${CurrentDir##*/}
DB_NAME=${CurrentDir//./_}

DB_PSW=`cat $BasePath/../$DB_NAME`

sed -i "s/maccms10/$DB_NAME/g" $BasePath/application/database.php

sed -i "s/root/$DB_NAME/g" $BasePath/application/database.php

sed -i "s/4rfv(IJN/$DB_PSW/g" $BasePath/application/database.php