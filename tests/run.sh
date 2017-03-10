#!/usr/bin/env bash

set -e
set -v

COMPOSE_FILE=./docker-compose.yml

if [[ -n ${CI_BUILD_NAME} ]]
then
    image=${CI_BUILD_NAME}
else
    image=php-${VERSION}-${VARIANT}
fi

echo "Building & testing: ${image}"

docker-compose build --pull ${image}

curl https://github.com/yiisoft/yii2/archive/master.tar.gz -o yii.tar.gz -L
tar -xzf yii.tar.gz

docker-compose run --rm ${image} \
    php /tests/requirements.php

docker-compose run --rm -w /tests/yii2-master ${image} \
    composer install
docker-compose run --rm -w /tests/yii2-master ${image} \
    vendor/bin/phpunit -v --exclude caching,db,data --log-junit tests/_junit/test.xml