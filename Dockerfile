
FROM ubuntu:16.04
MAINTAINER ARULKUMARAN CHANDRASEKARAN <arul@iterate.ai>

RUN ln -snf /bin/bash /bin/sh

ARG DEBIAN_FRONTEND=noninteractive

ENV PYENV_NAME pyenv
ENV N_CPUS 2
## Configure default locale

# utils for local testing
# ENV() { export $1=$2; }; COPY() { cp -rdv $1 $2; };

RUN apt-get update && \
    apt-get -y install apt-utils locales && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.utf8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

# Set environment
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV TERM xterm

ENV HOME /work
ENV SOFT $HOME/soft
ENV BASHRC $HOME/.bashrc

# Create a non-priviledge user that will run the services
ENV BASICUSER basicuser
ENV BASICUSER_UID 1000

RUN useradd -m -d $HOME -s /bin/bash -N -u $BASICUSER_UID $BASICUSER && \
    mkdir $SOFT && \
    mkdir $HOME/.scripts && \
    mkdir $HOME/.nipype
USER $BASICUSER
WORKDIR $HOME

# Add files.
COPY root/.* $HOME/
COPY root/* $HOME/
COPY root/.scripts/* $HOME/.scripts/
COPY root/.nipype/* $HOME/.nipype/

# debian and Install.
USER root
RUN \
    chown -R $BASICUSER $HOME && \
    apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository ppa:alex-p/tesseract-ocr && \
    apt-get update && \
    apt-get install -y wget bzip2 unzip htop curl git && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
build-essential \
apt-utils \
locales && \
rm -rf /var/lib/apt/lists/* && \
  apt-get install -y tesseract


# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen


#-------------------------------------------------------------------------------
## Here start the libraries that won't be installed in /usr/local
USER $BASICUSER


#-------------------------------------------------------------------------------
# Python environment with virtualenvwrapper
#-------------------------------------------------------------------------------
# Install Python 3 from miniconda

ENV PATH="$HOME/miniconda/bin:$PATH"

WORKDIR $SOFT
RUN \
  wget -O miniconda.sh \
     https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
  bash miniconda.sh -b -p $HOME/miniconda && \
  rm miniconda.sh && \
  echo "addpath \$HOME/miniconda/bin" >> $BASHRC && \
  conda update -y python conda && \
  conda config --add channels conda-forge && \
  conda install -y --no-deps \
matplotlib \
cycler \
freetype \
libpng \
pyparsing \
pytz \
python-dateutil \
six \
pip \
setuptools \
cython \
numpy \
scipy \
pandas \
scipy \
scikit-learn \
scikit-image \
statsmodels \
networkx \
pillow \
openblas \
&& conda clean -tipsy

# Install the other requirements
RUN pip install -r $HOME/requirements.txt && \
    rm -rf ~/.cache/pip/ && \
    source $BASHRC

#-------------------------------------------------------------------------------
# source .bashrc
#-------------------------------------------------------------------------------
USER root
RUN ldconfig

CMD ["/bin/bash"]
