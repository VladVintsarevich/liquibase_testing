#!/bin/bash
# Set script vars.
TARGET=local
SERVICE_NAME=testing
WEB_PORT=8088
DB_HOST=postgres-testing 		# when deployed in AWS will be RDS HostNAME
DB_PORT=5438
TEST_DB_NAME=test
TEST_DB_USER=postgres
TEST_DB_PASSWORD=password123

echo "Stop existing $SERVICE_NAME and $DB_HOST containers."
docker stop $SERVICE_NAME || true
docker rm $SERVICE_NAME || true
docker stop $DB_HOST || true
docker rm $DB_HOST || true

echo "Create network."
docker network create --driver bridge testing || true

echo "Start Postgres."
docker run -d -p $DB_PORT:5432 --net testing --name $DB_HOST -e POSTGRES_PASSWORD=$TEST_DB_PASSWORD -e POSTGRES_DB=$TEST_DB_NAME postgres:10.5


# Create the Rest Services image.
echo "*** Building TEST image ***"
docker build -t $SERVICE_NAME ./ \
--build-arg SPRING_PROFILES_ACTIVE=$TARGET \
--build-arg WEB_PORT=$WEB_PORT \
--build-arg DB_HOST=$DB_HOST \
--build-arg TEST_DB_NAME=$TEST_DB_NAME \
--build-arg TEST_DB_USER=$TEST_DB_USER \
--build-arg TEST_DB_PASSWORD=$TEST_DB_PASSWORD

[ $? -ne 0 ] && echo "TEST build failure" && exit 1

docker run -p $WEB_PORT:$WEB_PORT -t --net testing --name $SERVICE_NAME --rm $SERVICE_NAME
