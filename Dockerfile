FROM alpine:latest as downloader

ARG NOSO_VERSION
RUN apk add --no-cache wget
RUN wget -q https://github.com/DevTeamNoso/NosoWallet/releases/download/${NOSO_VERSION}/noso-${NOSO_VERSION}-x86_64-linux.tgz -O noso.tgz
RUN tar -zxvf noso.tgz

FROM ubuntu:latest

WORKDIR /app

ARG DEBIAN_FRONTEND noninteractive

RUN apt update &&\
    apt install -y --no-install-recommends libgtk2.0-0 xvfb &&\
    rm -rf /var/lib/apt/lists/*

COPY start.sh .
COPY advopt.txt .
COPY --from=downloader Noso .

RUN chmod +x Noso
 
ARG RESOLUTION="1000x1000x24"
ENV XVFB_RES="${RESOLUTION}"
ARG XARGS=""
ENV XVFB_ARGS="${XARGS}"
 
ENTRYPOINT ["/bin/bash", "start.sh"]
