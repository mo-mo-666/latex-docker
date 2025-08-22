FROM ubuntu:24.04

ARG TEXLIVE_VERSION="2024"
ARG TEXURL="https://mirror.nju.edu.cn/tex-historic/systems/texlive/${TEXLIVE_VERSION}/tlnet-final"
# see https://www.tug.org/historic/

ENV PATH /usr/local/bin/texlive:$PATH
WORKDIR /install-tl-unx
# change mirror server
RUN sed -i.bak -r 's@http://(jp\.)?archive\.ubuntu\.com/ubuntu/?@https://ftp.udx.icscoe.jp/Linux/ubuntu/@g' /etc/apt/sources.list.d/ubuntu.sources \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    perl \
    wget \
    xz-utils \
    fontconfig \
    perl \
    cpanminus \
    openssh-server \
    && apt-get clean \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*
RUN  cpanm 'Log::Log4perl' 'Log::Dispatch::File' 'YAML::Tiny' 'File::HomeDir' 'Unicode::GCString'
COPY ./texlive.profile ./
RUN wget -N --no-check-certificate ${TEXURL}/install-tl-unx.tar.gz \
    && tar xvf install-tl-unx.tar.gz --strip-components=1 \
    && ./install-tl --no-interaction --profile=texlive.profile -repository ${TEXURL} \
    && rm /install-tl-unx.tar.gz \
    && rm -rf /install-tl-unx
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive

ENV LANG=ja_JP.UTF-8
ENV LANGUAGE="ja_JP:ja"
WORKDIR /workdir
# home directory for root
COPY .latexmkrc /root
COPY .chktexrc /root
COPY .latexindentrc.yaml /root
COPY .indentconfig.yaml /root

CMD ["bash"]
