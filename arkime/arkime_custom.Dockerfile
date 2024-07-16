FROM golang:1.22-alpine

ENV ES_HOST "elasticsearch"
ENV ES_PORT 9200
ENV ARKIME_ADMIN_USERNAME "selks-user"
ENV ARKIME_ADMIN_PASSWORD "selks-user"
ENV ARKIME_HOSTNAME "arkime"
ENV ARKIMEDIR "/opt/arkime"

WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./...
ENV CGO_ENABLED=0
RUN go build -v -ldflags="-s -w" -o arkime-supervisor

FROM ubuntu:22.04

ENV VER=5.0.0

RUN apt update && \
    apt install -y curl wget libwww-perl libjson-perl ethtool libyaml-dev jq libmagic1 iproute2 liblua5.4-0 libmaxminddb0 libpcap0.8 libglib2.0-0 libyara8 librdkafka1 && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L https://github.com/arkime/arkime/releases/download/v$VER/arkime_$VER-1.ubuntu2204_arm64.deb -o /opt/arkime_$VER-1_arm64.deb && \
    dpkg -i /opt/arkime_$VER-1_arm64.deb && \
    rm /opt/arkime_$VER-1_arm64.deb

COPY start-arkimeviewer.sh /start-arkimeviewer.sh
COPY arkimepcapread-selks-config.ini /opt/arkime/etc/config.ini
RUN chmod 755 /start-arkimeviewer.sh && \
    mkdir -p /readpcap

COPY --from=0 /go/src/app/arkime-supervisor /opt/arkime/

EXPOSE 8005

WORKDIR /opt/arkime

ENTRYPOINT [ "bash", "-c" ]
CMD ["/start-arkimeviewer.sh"]