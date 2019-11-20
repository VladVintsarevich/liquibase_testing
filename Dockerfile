# Set global variables.
ARG SPRING_PROFILES_ACTIVE=local
ARG WEB_PORT=8088
ARG DB_HOST
ARG TEST_DB_NAME
ARG DB_PORT
ARG TEST_DB_USER
ARG TEST_DB_PASSWORD

# Build stage.
FROM maven:3.6.1-jdk-11-slim as build-stage

WORKDIR /local/apps/testing

# Cache Maven artifacts
COPY pom.xml .
RUN mvn -U dependency:go-offline

# Copy source and run build.
COPY . .

# Set environment vars for tests.
ARG SPRING_PROFILES_ACTIVE
ENV SPRING_PROFILES_ACTIVE $SPRING_PROFILES_ACTIVE

ARG WEB_PORT
ENV WEB_PORT $WEB_PORT

ARG DB_HOST
ENV DB_HOST $DB_HOST

ARG TEST_DB_NAME
ENV TEST_DB_NAME $TEST_DB_NAME

ARG DB_PORT
ENV DB_PORT $DB_PORT

ARG TEST_DB_USER
ENV TEST_DB_USER $TEST_DB_USER

ARG TEST_DB_PASSWORD
ENV TEST_DB_PASSWORD $TEST_DB_PASSWORD

# Separate layer for dependencies.
RUN mvn clean package

# production stage
FROM openjdk:11.0.3-jre-stretch as production_stage

COPY --from=build-stage /local/apps/testing/target/*.war /local/apps/testing/

# Set environment vars for app.
ARG SPRING_PROFILES_ACTIVE
ENV SPRING_PROFILES_ACTIVE $SPRING_PROFILES_ACTIVE

ARG WEB_PORT
ENV WEB_PORT $WEB_PORT

ARG DB_HOST
ENV DB_HOST $DB_HOST

ARG TEST_DB_NAME
ENV TEST_DB_NAME $TEST_DB_NAME

ARG DB_PORT
ENV DB_PORT $DB_PORT

ARG TEST_DB_USER
ENV TEST_DB_USER $TEST_DB_USER

ARG TEST_DB_PASSWORD
ENV TEST_DB_PASSWORD $TEST_DB_PASSWORD

#RUN apt-get update && apt-get upgrade
#RUN apt-get update \
#	&& apt-get add bash zip unzip

ENTRYPOINT ["java","-jar","/local/apps/testing/testing-0.0.1-SNAPSHOT.war"]
