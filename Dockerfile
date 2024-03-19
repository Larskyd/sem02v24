ARG DEBIAN_FRONTEND=noninteractive
FROM ubuntu:24.04
RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get autoremove -y \
 && apt-get autoclean -y \
 && apt-get install -y \
 sudo \
 nano \
 wget \
 curl \
 git \
 build-essential \
 gcc \
 openjdk-21-jdk \
 mono-complete \
 python3 \
 strace \
 valgrind

RUN useradd -G sudo -m -d /home/larskyd -s /bin/bash -p "$(openssl passwd -1 1234)" larskyd
USER larskyd
WORKDIR /home/larskyd
RUN mkdir hacking \
 && cd hacking \
 && curl -SL https://raw.githubusercontent.com/uia-worker/is105misc/master/sem01v24/pawned.sh > pawned.sh \
 && chmod 764 pawned.sh \
 && cd ..
RUN git config --global user.email "larsky@uia.no" \
 && git config --global user.name "Lars Kydland" \
 && git config --global url."https://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:@github.com/".insteadOf "https://github.com" \
 && mkdir -p github.com/GITHUB-larskyd/sem02v24
USER root
RUN curl -SL https://go.dev/dl/go1.21.7.linux-amd64.tar.gz \
 | tar xvz -C /usr/local
USER larskyd
SHELL ["/bin/bash", "-c"]
RUN mkdir -p $HOME/go/{src,bin}
ENV GOPATH="/home/larskyd/go"
ENV PATH="${PATH}:${GOPATH}/bin:/usr/local/go/bin"

RUN curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf \
 | sh -s -- -y
ENV PATH="${PATH}:${HOME}/.cargo/bin"