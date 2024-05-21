FROM golang:1.22 as builder

WORKDIR /usr/src/app

COPY . .

ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=1

RUN go build .

FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    bison \
    gawk \
    python3 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /glibc_install
WORKDIR /glibc_install
RUN wget http://ftp.gnu.org/gnu/glibc/glibc-2.34.tar.gz
RUN tar zxvf glibc-2.34.tar.gz
WORKDIR /glibc_install/glibc-2.34
RUN mkdir build
WORKDIR /glibc_install/glibc-2.34/build
RUN ../configure --prefix=/opt/glibc-2.34
RUN make -j4
RUN make install

WORKDIR /app

COPY --from=builder /usr/src/app/sqlite-linux-repro .

ENV LD_PRELOAD=/opt/glibc-2.34/lib/libc.so.6

ENTRYPOINT ["./sqlite-linux-repro"]
