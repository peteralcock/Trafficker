#!/bin/bash -ex

echo '-- BUILDING SLAMMER... --'
cd ./user-sync
rm -rf target && mvn -Popendj clean package

cd ../auth-proxy
mvn clean compile package
java -Djava.util.logging.config.file=conf/logging.properties -jar target/slammer-proxy-0.1-SNAPSHOT.jar

cd ../devenv
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker-compose up -d

cd ./ldap/eclecticlabs
vagrant up &

cd ../nypd
vagrant up &


exit 0
