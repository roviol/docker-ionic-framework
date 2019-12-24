FROM  ubuntu:18.04
LABEL maintainer="rolandoviol [at] gmail [dot] com"

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk-linux \
    NODE_VERSION=10.13.0 \
    NPM_VERSION=6.4.1 \
    IONIC_VERSION=5.4.13 \
    CORDOVA_VERSION=9.0.0 \
    GRADLE_VERSION=5.6.4

# Install basics
RUN apt-get update &&  \
    apt-get install -y git wget curl unzip build-essential ruby ruby-dev ruby-ffi gcc make software-properties-common

RUN curl --retry 3 -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" && \
    tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 && \
    rm "node-v$NODE_VERSION-linux-x64.tar.gz" && \
    npm install -g npm@"$NPM_VERSION" && \
    npm install -g cordova@"$CORDOVA_VERSION" ionic@"$IONIC_VERSION" && \
    npm cache verify && \
    gem install sass && \
    git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
    ionic start myApp sidemenu --no-interactive

#ANDROID STUFF
RUN echo ANDROID_HOME="${ANDROID_HOME}" >> /etc/environment && \
    dpkg --add-architecture i386 && \
    apt-get install -y expect ant wget zipalign libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 qemu-kvm kmod openjdk-8-jdk && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-"$GRADLE_VERSION"-bin.zip && \
    mkdir /opt/gradle && \
    unzip -d /opt/gradle gradle-"$GRADLE_VERSION"-bin.zip && \
    rm -rf gradle-"$GRADLE_VERSION"-bin.zip

# Install Android SDK
RUN mkdir -p $ANDROID_HOME && \
    cd $ANDROID_HOME && \
    wget --output-document=android-sdk.zip --quiet https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip android-sdk.zip && \
    rm -f android-sdk.zip && \
    chown -R root. /opt

RUN update-java-alternatives -s java-1.8.0-openjdk-amd64

RUN mkdir -p $ANDROID_HOME/licenses || true && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > $ANDROID_HOME/licenses/android-sdk-license && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses && \
    $ANDROID_HOME/tools/bin/sdkmanager "platform-tools" "platforms;android-28" "build-tools;29.0.2" && \
    $ANDROID_HOME/tools/bin/sdkmanager --update

# Setup environment

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin:/opt/gradle/gradle-"$GRADLE_VERSION"/bin


WORKDIR myApp
EXPOSE 8100 35729
#CMD ["ionic", "serve"]
