FROM ubuntu:22.04@sha256:bbf3d1baa208b7649d1d0264ef7d522e1dc0deeeaaf6085bf8e4618867f03494

ARG TEXLIVE_VERSION="2022"
ARG TEXURL="ftp://tug.org/historic/systems/texlive/${TEXLIVE_VERSION}/tlnet-final"

WORKDIR /install-tl-unx
RUN apt-get update
RUN apt-get install -y \
    perl \
    wget \
    xz-utils \
    fontconfig \
    perl \
    cpanminus
RUN  cpanm 'Log::Log4perl' 'Log::Dispatch::File' 'YAML::Tiny' 'File::HomeDir' 'Unicode::GCString'
COPY ./texlive.profile ./
RUN wget -N ${TEXURL}/install-tl-unx.tar.gz \
    && tar xvf install-tl-unx.tar.gz --strip-components=1
RUN ./install-tl -no-gui --profile=texlive.profile -repository ${TEXURL}
RUN rm -rf /install-tl-unx

WORKDIR /workdir
COPY .latexmkrc /root
COPY .chktexrc /root
COPY .latexindentrc.yaml /root
COPY .indentconfig.yaml /root

CMD ["bash"]
