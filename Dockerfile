FROM kshivaprasad/java:1.8
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y p7zip \
    p7zip-full \
    unace \
    zip \
    unzip \
    bzip2
 #Version numbers
 ARG FIREFOX_VERSION=78.0.2
 ARG CHROME_VERSION=83.0.4103.116
 ARG CHROMDRIVER_VERSION=83.0.4103.39
 ARG FIREFOXDRIVER_VERSION=0.26.0

 #Step 2: Install Chrome
 RUN curl http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_$CHROME_VERSION-1_amd64.deb -o /chrome.deb
 RUN dpkg -f /chrome.deb
 RUN rm /chrome.deb
 #Step 3: Install chromedriver for Selenium
 RUN mkdir -p /app/bin
 RUN curl https://chromedriver.storage.googleapis.com/$CHROMDRIVER_VERSION/chromedriver_linux64.zip -o /tmp/chromedriver.zip \
     && unzip /tmp/chromedriver.zip -d /app/bin/ \
     && rm /tmp/chromedriver.zip
 RUN chmod +x /app/bin/chromedriver
 #Step 4 : Install firefox
 RUN wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
   && bunzip2 /tmp/firefox.tar.bz2 \
   && tar xvf /tmp/firefox.tar \
   && mv /firefox /opt/firefox-$FIREFOX_VERSION \
   && ln -s /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox
 #Step 5: Install Geckodriver
 RUN wget https://github.com/mozilla/geckodriver/releases/download/v$FIREFOXDRIVER_VERSION/geckodriver-v$FIREFOXDRIVER_VERSION-linux64.tar.gz \
     && tar -xf geckodriver-v0.26.0-linux64.tar.gz \
     && cp geckodriver /app/bin/geckodriver
 RUN chmod +x /app/bin/geckodriver
 #Step 6: Install Maven
 # 1- Define Maven version
 ARG MAVEN_VERSION=3.8.4
 # 2- Define a constant with the working directory
 ARG USER_HOME_DIR="/root"
ARG SHA=a9b2d825eacf2e771ed5d6b0e01398589ac1bfa4171f36154d1b5787879605507802f699da6f7cfc80732a5282fd31b28e4cd6052338cbef0fa1358b48a5e3c8
ARG BASE_URL=https://downloads.apache.org//maven/maven-3/${MAVEN_VERSION}/binaries

# 5- Create the directories, download maven, validate the download, install it, remove downloaded file and set links
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && echo "Downlaoding maven" \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  \
  && echo "Checking download hash" \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  \
  && echo "Unziping maven" \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# 6- Define environmental variables required by Maven, like Maven_Home directory and where the maven repo is located
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY . /app
#RUN mvn -f /app/pom.xml clean package
#RUN cp /app/target/SeleniumDocker-1.0-SNAPSHOT-fat-tests.jar /app/SeleniumDocker-1.0-SNAPSHOT-fat-tests.jar
WORKDIR /app
RUN chmod +x /app/bin/chromedriver
RUN chmod +x /app/bin/geckodriver