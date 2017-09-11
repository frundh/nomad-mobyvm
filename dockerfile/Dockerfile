FROM alpine:3.5

ENV NOMAD_VERSION 0.6.2.1

ENV GOLANG_VERSION 1.8.1
ENV GOLANG_SRC_URL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz
ENV GOLANG_SRC_SHA256 33daf4c03f86120fdfdc66bddf6bfff4661c7ca11c5da473e537f4d69b470e57

# Compile and install nomad, consul and fabio.
RUN set -ex \
  && echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && apk update; apk upgrade \
  && apk add --no-cache --virtual .build-deps \
    bash \
    go \
    curl \
    make \
    git \
    gcc \
    musl-dev \
    openssl \
    openssl-dev \
  \
  # Compile go \
  \
  && export GOROOT_BOOTSTRAP="$(go env GOROOT)" \
  && wget -q "$GOLANG_SRC_URL" -O golang.tar.gz \
  && echo "$GOLANG_SRC_SHA256  golang.tar.gz" | sha256sum -c - \
  && tar -C /usr/local -xzf golang.tar.gz \
  && rm golang.tar.gz \
  && cd /usr/local/go/src \
  && ./make.bash \
  \
  && export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH \
  && mkdir /go \
  && cd /go \
  && ln -s . src \
  && export GOPATH=/go \
  && go get github.com/Masterminds/glide \
  && cp /go/bin/* /usr/local/bin \
  \
  # Compile nomad \
  \
  #&& go get github.com/frundh/nomad \
  #&& go build github.com/frundh/nomad \
  #&& mv nomad /bin \ 

  && cd $GOPATH \
  && mkdir -p {src,bin,pkg} \
  && mkdir -p src/github.com/hashicorp/ \
  && cd src/github.com/hashicorp/ \
  && git clone -b ip-from-env-var https://github.com/frundh/nomad.git \
  && cd nomad/ \
  && go get ./ \
  && go install github.com/hashicorp/nomad \
  && mv $GOPATH/bin/nomad /bin \
  
  && chmod +x /bin/nomad \
  
  # Cleanup \
  \
  && rm -rf /go \
  && apk del .build-deps \
  && rm -rf /usr/local/go \
  && rm -rf /var/cache/apk/* \
  && rm -rf /root/.glide \
  && rm /usr/local/bin/glide


RUN addgroup nomad && \
    adduser -S -G nomad nomad

ENV GLIBC_VERSION "2.23-r1"
ENV GOSU_VERSION 1.9

RUN set -x && \
    apk --update add --no-cache --virtual .gosu-deps tzdata dpkg curl ca-certificates gnupg libcap openssl && \
    curl -Ls https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk > /tmp/glibc-${GLIBC_VERSION}.apk && \
    apk add --allow-untrusted /tmp/glibc-${GLIBC_VERSION}.apk && \
    rm -rf /tmp/glibc-${GLIBC_VERSION}.apk /var/cache/apk/* && \
    wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 && \
    chmod +x /usr/local/bin/dumb-init && \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    apk del .gosu-deps

RUN mkdir -p /nomad/data && \
    mkdir -p /etc/nomad && \
    chown -R nomad:nomad /nomad

EXPOSE 4646 4647 4648

ADD start.sh /usr/local/bin/start.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]