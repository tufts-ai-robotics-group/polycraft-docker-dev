FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y \
    git
# Python packages
RUN apt-get install -y \
    python3.8-dev \
    python3-pip
RUN pip3 install pipenv
# PAL packages
RUN apt-get install -y \
    openjdk-8-jdk \
    gradle
# ADE packages
RUN apt-get install -y \
    ant \
    openjdk-8-jdk

# TODO separate installing dependencies, cloning, and building as stages

# copy ssh key provided in folder
RUN mkdir /root/.ssh/
COPY id_rsa /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa
# create known_hosts and add DIARC git repo key and github key
RUN touch /root/.ssh/known_hosts && \
    ssh-keyscan -t rsa -p 22222 hrilab.tufts.edu >> /root/.ssh/known_hosts && \
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

# Set correct encoding for Python 
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# create code dir
ENV CODE_DIR /home/docker/code
RUN mkdir -p ${CODE_DIR}
WORKDIR ${CODE_DIR}

# clone and set up PAL
WORKDIR ${CODE_DIR}
RUN git clone -b release_1.3 --single-branch https://github.com/StephenGss/PAL.git
WORKDIR ${CODE_DIR}/PAL/setup
RUN bash setup_linux_shortened.sh
# clone and build ADE
WORKDIR ${CODE_DIR}
RUN git clone -b polycraft-v1 --single-branch ssh://git@hrilab.tufts.edu:22222/ade/ade.git
WORKDIR ${CODE_DIR}/ade
RUN ant
# clone NovelGridworlds
WORKDIR ${CODE_DIR}
RUN git clone -b master --single-branch https://github.com/gtatiya/gym-novel-gridworlds.git
# clone polycraft_tufts
WORKDIR ${CODE_DIR}
RUN git clone -b master --single-branch git@github.com:tufts-ai-robotics-group/polycraft_tufts.git
# clone polycraft-novelty-detection
WORKDIR ${CODE_DIR}
RUN git clone --recurse-submodules https://github.com/tufts-ai-robotics-group/polycraft-novelty-detection.git
# set up pipenv
WORKDIR ${CODE_DIR}
RUN pipenv install --skip-lock \
    -r ${CODE_DIR}/PAL/requirements.txt \
    pandas \
    astar \
    -e gym-novel-gridworlds \
    torch \
    torchvision \
    torchaudio \
    -e polycraft-novelty-detection \
    -e polycraft-novelty-detection/submodules/polycraft-novelty-data

# remove SSH key
RUN rm /root/.ssh/id_rsa

# copy scripts from repo
ENV SCRIPTS_DIR /home/docker/scripts
COPY docker_scripts ${SCRIPTS_DIR}
# replace default PAL config.py
COPY polycraft_config/config.py ${CODE_DIR}/PAL/PolycraftAIGym/config.py

# set final working directory
WORKDIR ${SCRIPTS_DIR}
