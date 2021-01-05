FROM kalilinux/kali-rolling
ARG KALI_DESKTOP
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y \
        curl sudo apt-transport-https gnupg \
        x11vnc xvfb novnc dbus-x11 \
        kali-defaults kali-desktop-${KALI_DESKTOP} && \
    apt-get clean
EXPOSE 5900/tcp 6080/tcp
ENV DISPLAY :1
ENV KALI_DESKTOP ${KALI_DESKTOP}

ENTRYPOINT ["/init"]
ARG S6_OVERLAY_VERSION=2.1.0.2
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C / && \
    rm -f /tmp/s6-overlay-amd64.tar.gz
COPY etc/ /etc