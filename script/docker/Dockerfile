FROM debian:bookworm AS base

FROM base AS build

RUN apt-get -y update && \
    apt-get -y install \
        cmake make g++ \
        gettext libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev

WORKDIR /build
RUN --mount=src=.,target=/src,rw \
    --mount=id=fheroes2-build,type=cache,target=/build \
    mkdir -p /app && \
    cd /build && \
    cmake /src \
        -DCMAKE_INSTALL_PREFIX=/app && \
    make -j4 && \
    make install

FROM base AS final

RUN echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
        apt-get -y update && apt-get -y install \
            libgl1 \
            libsdl2-2.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0

WORKDIR /app
COPY --link --from=build /app/bin/ /app/
COPY --link --from=build /data/files ./files
COPY --link ./data ./data
COPY --link ./anim ./anim
COPY --link ./maps ./maps

CMD ["/app/fheroes2"]
