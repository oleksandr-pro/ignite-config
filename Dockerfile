# Start from GridGain Professional image.
FROM gridgain/community

# Set config uri for node.
ENV CONFIG_URI thin-server-server.xml

# Copy optional libs.
ENV OPTION_LIBS ignite-rest-http

# Update packages and install maven.
RUN set -x \
    && apk add --no-cache \
        openjdk8

RUN apk --update add \
    maven \
    && rm -rfv /var/cache/apk/*

# Append project to container.
ADD . thin-server

# Build project in container.
RUN mvn -f thin-server/pom.xml clean package -DskipTests

# Copy project jars to node classpath.
RUN mkdir $IGNITE_HOME/libs/thin-server && \
   find thin-server/target -name "*.jar" -type f -exec cp {} $IGNITE_HOME/libs/thin-server \;