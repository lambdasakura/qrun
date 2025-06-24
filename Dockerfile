FROM ubuntu:latest
RUN apt-get update && apt-get install -y wget libayatana-appindicator3-1 \
                                              libwebkit2gtk-4.1-0 \
                                              libgtk-3-0

RUN wget https://desktop-release.q.us-east-1.amazonaws.com/latest/amazon-q.deb && \
    apt-get update && apt-get install -f && dpkg -i amazon-q.deb && rm amazon-q.deb
