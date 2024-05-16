FROM eclipse-temurin:17-jdk-jammy AS build

WORKDIR /app
COPY . /app/

RUN java --version
RUN ./mvnw clean install -Dmaven.test.skip=true

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

COPY --from=build /app/target/configuration-server*.jar /app/
RUN find /app -iname configuration-server-\* -exec ln -sf '{}' /app/configuration-server.jar \;

RUN ls -l /app

ENV JAVA_OPTS "-Xms512m -Xmx512m"
#ENV APP_ARGS "-Dspring.config.location=/app/conf/application.properties "
ENV PROFILE_ARGS "-Dspring.profiles.active=dev"

HEALTHCHECK CMD nc -z localhost 8888
EXPOSE 8888

CMD java $JAVA_OPTS $APP_ARGS -jar /app/configuration-server.jar
