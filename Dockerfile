FROM debian:9 as builder

RUN apt-get update && apt-get install -y \
		autoconf \
		g++ \
		git \
		libavcodec-dev \
		libavformat-dev \
		libavutil-dev \
		libc-ares-dev \
		libcrypto++-dev \
		libcurl4-openssl-dev \
		libfreeimage-dev \
		libmediainfo-dev \
		libreadline-dev \
		libsodium-dev \
		libsqlite3-dev \
		libssl-dev \
		libswscale-dev \
		libtool \
		libuv1-dev \
		libzen-dev \
		make \
		zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

ARG MEGACMD_VERSION=1.0.0

RUN git clone -b ${MEGACMD_VERSION} --recurse-submodules https://github.com/meganz/MEGAcmd.git megacmd

WORKDIR megacmd

RUN ./autogen.sh
RUN ./configure --prefix /usr
RUN make
RUN make install DESTDIR=/usr/src/output

FROM debian:9

RUN apt-get update && apt-get install -y \
		libavcodec57 \
		libavformat57 \
		libavutil55 \
		libc-ares2 \
		libcrypto++6 \
		libcurl3 \
		libfreeimage3 \
		libmediainfo0v5 \
		libreadline7 \
		libsodium18 \
		libsqlite3-0 \
		libssl1.1 \
		libswscale4 \
		libuv1 \
		libzen0v5 \
		zlib1g \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/output /

CMD [ "mega-cmd-server" ]
