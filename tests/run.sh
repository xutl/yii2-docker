#!/usr/bin/env bash

set -e

image=php-${VERSION}-${VARIANT}

echo "Building & testing: ${image}"

docker-compose build --pull ${image}

# Download Yii2 for running requirement checks & tests
curl https://github.com/yiisoft/yii2/archive/master.tar.gz -o yii.tar.gz -L
tar -xzf yii.tar.gz

# Install framework dependencies
docker-compose run --rm -w /tests/yii2-master ${image} \
    composer install

# Run requirement checks
docker-compose run --rm ${image} \
    php /tests/requirements.php

# Run subset of test-suite
docker-compose run --rm -w /tests/yii2-master ${image} \
    vendor/bin/phpunit -v --exclude caching,db,data --log-junit tests/_junit/test.xml