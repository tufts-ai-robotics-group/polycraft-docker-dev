FROM nvidia/cuda:10.2-base-ubuntu18.04 AS dependency

# update outdated CUDA keys
RUN rm /etc/apt/sources.list.d/cuda.list && \
    rm /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-key del 7fa2af80 && \
    apt-get update && apt-get install -y --no-install-recommends wget && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb
# update packages and install git
RUN apt-get update
RUN apt-get install -y \
    git
# Python packages
RUN apt-get install -y \
    python3.8-dev \
    python3-pip
RUN python3.8 -m pip install pipenv
# PAL packages
RUN apt-get install -y \
    openjdk-8-jdk \
    gradle
# ADE packages
RUN apt-get install -y \
    ant \
    openjdk-8-jdk


FROM dependency AS clone
# copy ssh key provided in folder
RUN mkdir /root/.ssh/
COPY id_rsa /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa
# create known_hosts and add DIARC git repo key and github key
RUN touch /root/.ssh/known_hosts && \
    ssh-keyscan -t rsa -p 22222 hrilab.tufts.edu >> /root/.ssh/known_hosts && \
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

# create code dir
ENV CODE_DIR /home/docker/code
RUN mkdir -p ${CODE_DIR}
WORKDIR ${CODE_DIR}

# clone PAL
WORKDIR ${CODE_DIR}
RUN git clone -b release_2.0 --single-branch https://github.com/StephenGss/PAL.git
# clone ADE
WORKDIR ${CODE_DIR}
RUN git clone -b polycraft-v2 --single-branch ssh://git@hrilab.tufts.edu:22222/ade/ade.git
# clone NovelGridworlds
WORKDIR ${CODE_DIR}
RUN git clone -b master --single-branch https://github.com/gtatiya/gym-novel-gridworlds.git
# clone polycraft_tufts
WORKDIR ${CODE_DIR}
RUN git clone -b master --single-branch git@github.com:tufts-ai-robotics-group/polycraft_tufts.git
# clone polycraft-novelty-detection
WORKDIR ${CODE_DIR}
RUN git clone --recurse-submodules https://github.com/tufts-ai-robotics-group/polycraft-novelty-detection.git


FROM clone AS build
# set correct encoding for Python 
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# set up PAL
WORKDIR ${CODE_DIR}/PAL/setup
RUN bash setup_linux_shortened.sh
# set Java 8 as default and build PAL
WORKDIR ${CODE_DIR}/PAL
RUN update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac \
  && update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
RUN ./gradlew build
# build ADE
WORKDIR ${CODE_DIR}/ade
RUN ant
# set up pipenv
WORKDIR ${CODE_DIR}
RUN python3.8 -m pipenv install --skip-lock --python 3.8 \
    pandas \
    torch \
    torchvision \
    torchaudio \
    -e polycraft-novelty-detection \
    -e polycraft-novelty-detection/submodules/polycraft-novelty-data \
    # PAL requirements but looser
    # -r ${CODE_DIR}/PAL/requirements.txt \
    astar \
    azure-cosmosdb-table \
    azure-storage-blob \
    matplotlib \
    statsmodels \
    pyodbc \
    filelock \
    psutil
    # -e gym-novel-gridworlds \


FROM build as final
# copy scripts from repo
ENV SCRIPTS_DIR /home/docker/scripts
COPY docker_scripts ${SCRIPTS_DIR}
# replace default PAL config.py
COPY polycraft_config/config.py ${CODE_DIR}/PAL/PolycraftAIGym/config.py

# set final working directory
WORKDIR ${SCRIPTS_DIR}
