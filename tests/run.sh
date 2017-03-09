#!/usr/bin/env bash

COMPOSE_FILE=./docker-compose.yml

VERSION=7.1
VARIANT=apache

image=php-${VERSION}-${VARIANT}

docker-compose build --pull ${image}

docker-compose run --rm ${image} \
    composer create-project --prefer-dist yiisoft/yii2 /tests/yii2

docker-compose run --rm ${image} \
    php /tests/yii2/framework/requirements/requirements.php

docker-compose run --rm ${image} -w /tests/yii2 \
    vendor/bin/phpunit -v --exclude caching,db,data --log-junit tests/_junit/test.xml