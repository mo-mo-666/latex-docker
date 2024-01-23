FROM ubuntu:22.04@sha256:bbf3d1baa208b7649d1d0264ef7d522e1dc0deeeaaf6085bf8e4618867f03494

ARG TEXLIVE_VERSION="2022"
ARG TEXURL="https://mirror.nju.edu.cn/tex-historic/systems/texlive/${TEXLIVE_VERSION}/tlnet-final"
# see https://www.tug.org/historic/

ENV PATH /usr/local/bin/texlive:$PATH
WORKDIR /install-tl-unx
# change mirror server
RUN sed -i.org -e 's|archive.ubuntu.com|ubuntutym.u-toyama.ac.jp|g' /etc/apt/sources.list \
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
    && apt-get clean \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*
RUN  cpanm 'Log::Log4perl' 'Log::Dispatch::File' 'YAML::Tiny' 'File::HomeDir' 'Unicode::GCString'
COPY ./texlive.profile ./
RUN wget -N --no-check-certificate ${TEXURL}/install-tl-unx.tar.gz \
    && tar xvf install-tl-unx.tar.gz --strip-components=1 \
    && ./install-tl --no-interaction --profile=texlive.profile -repository ${TEXURL} \
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
