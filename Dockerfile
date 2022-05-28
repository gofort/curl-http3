FROM ubuntu:22.04

RUN echo "\n\n\033[0;32m===> INSTALLING BUILD DEPENDANCIES\033[0m" && \
      apt update && \
      apt install -y build-essential git autoconf libtool pkg-config && \
# remove existing curl if present
      echo "\n\n\033[0;32m===> REMOVING EXISTING CURL INSTALL\033[0m" && \
      apt purge -y curl && \
# build openssl
      echo "\n\n\033[0;32m===> BUILD OPENSSL\033[0m" && \
      git clone --depth 1 -b openssl-3.0.3+quic https://github.com/quictls/openssl && \
      cd openssl && \
      ./config enable-tls1_3 --prefix=/usr/local && \
      make -j `lscpu | awk /"^Core"/'{print$NF}'` && \
      make install && \
      cd ../ && \
# build nghttp3
      echo "\n\n\033[0;32m===> BUILD NGHTTP3\033[0m" && \
      git clone https://github.com/ngtcp2/nghttp3 && \
      cd nghttp3 && \
      autoreconf -fi && \
      ./configure --prefix=/usr/local --enable-lib-only && \
      make -j `lscpu | awk /"^Core"/'{print$NF}'` && \
      make install && \
      cd ../ && \
# build ngtcp2
      echo \n\n"\033[0;32m===> BUILD NGTCP2\033[0m" && \
      git clone https://github.com/ngtcp2/ngtcp2 && \
      cd ngtcp2 && \
      autoreconf -fi && \
      ./configure PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig LDFLAGS="-Wl,-rpath,/usr/local/lib64" --prefix=/usr/local --enable-lib-only && \
      make -j `lscpu | awk /"^Core"/'{print$NF}'` && \
      make install && \
      cd ../ && \
# build curl
      echo "\n\n\033[0;32m===> BUILD CURL\033[0m" && \
      git clone https://github.com/curl/curl && \
      cd curl && \
      ./buildconf && \
      LDFLAGS="-Wl,-rpath,/usr/local/lib64" ./configure --with-openssl=/usr/local --with-nghttp3=/usr/local --with-ngtcp2=/usr/local && \
      make -j `lscpu | awk /"^Core"/'{print$NF}'` && \
      make install && \
      cd ../ && \
      ldconfig && \
# cleanup
      echo "\n\n\033[0;32m===> CLEANUP\033[0m" && \
      apt purge build-essential git autoconf libtool pkg-config -y && \
      apt clean all && \
      rm -rf openssl nghttp3 ngtcp2 curl && \
# check
      echo "\n\n\033[0;32m===> CHECK\033[0m" && \
      curl --version

# Last bits
ENTRYPOINT ["curl"]
