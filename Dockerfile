FROM debian:stable-slim

ARG USER_NAME=latex
ARG USER_HOME=/home/latex
ARG USER_ID=1000
ARG USER_GECOS=LaTeX

RUN sed -i 's/main/main contrib/g' /etc/apt/sources.list.d/debian.sources

RUN apt-get update && \
  echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections && \
  apt-get install --no-install-recommends -y \
  adduser \
  chktex \
  ghostscript \
  lacheck \
  latexmk \
  texlive \
  texlive-xetex \
  texlive-lang-cyrillic \
  texlive-lang-english \
  texlive-fonts-extra \
  texlive-fonts-recommended \
  texlive-science \
  texlive-latex-extra \
  texlive-pictures \
  ttf-mscorefonts-installer \
  fonts-texgyre \
	fonts-texgyre-math \
  && \
  apt-get --purge remove -y .\*-doc$ && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/*

RUN adduser \
  --home "${USER_HOME}" \
  --uid "${USER_ID}" \
  --gecos "${USER_GECOS}" \
  --disabled-password \
  "${USER_NAME}"
