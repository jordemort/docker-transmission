FROM debian:bullseye-slim AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y build-essential cmake libcurl4-openssl-dev libssl-dev python3 python3.9-dev xz-utils

ARG TRANSMISSION_VERSION=4.0.2
ARG DIRNAME=transmission-${TRANSMISSION_VERSION}
ARG TARBALL=${DIRNAME}.tar.xz
ARG SRCDIR=/usr/src/${DIRNAME}
ARG BUILDDIR=${SRCDIR}/build

ADD https://github.com/transmission/transmission/releases/download/${TRANSMISSION_VERSION}/${TARBALL} /usr/src/

WORKDIR /usr/src

RUN tar -xvf ${TARBALL} && mkdir ${BUILDDIR}

WORKDIR ${BUILDDIR}

RUN cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
RUN make
RUN env DESTDIR=/tmp/install make install

##########

FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y dumb-init gosu libcurl4 libssl1.1 libstdc++6 && apt-get clean

COPY --from=build /tmp/install/usr/local/ /usr/local/

ARG DEFAULT_PUID=1000
ARG DEFAULT_PGID=1000

ENV PUID=${DEFAULT_PUID} PGID=${DEFAULT_PGID}

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN mkdir /config /downloads /watch && chown ${DEFAULT_PUID}:${DEFAULT_PGID} /config /downloads /watch

VOLUME [ "/config", "/downloads", "/watch" ]

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]

CMD [ "transmission-daemon", "-f", "-g", "/config", "-w", "/downloads", "-c", "/watch" ]

HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=3 CMD [ "transmission-remote", "-pt" ]
