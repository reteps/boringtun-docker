FROM rust:1.40-slim-buster AS builder

WORKDIR /src
COPY boringtun .
RUN cargo build --release \
    && strip ./target/release/boringtun

FROM debian:bookworm-slim

WORKDIR /app
COPY --from=builder /src/target/release/boringtun /app

ENV WG_LOG_LEVEL=info \
    WG_THREADS=4

RUN apt-get update && apt-get install -y --no-install-suggests wireguard-tools iproute2 iptables tcpdump \
libgconf-2-4 libatk1.0-0 libatk-bridge2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 libgbm-dev libnss3-dev libxss-dev
CMD ["wg-quick", "up", "$1"]
