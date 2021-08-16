FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y \
    git
# copy GitLab ssh key provided in folder
RUN mkdir /root/.ssh/
COPY id_rsa /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa
# create known_hosts and add DIARC git repo key and github key
RUN touch /root/.ssh/known_hosts && \
    ssh-keyscan -t rsa -p 22222 hrilab.tufts.edu >> /root/.ssh/known_hosts && \
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
# create code dir
ENV CODE /home/docker/code
RUN mkdir -p ${CODE}
WORKDIR ${CODE}
# clone PAL
WORKDIR ${CODE}
RUN git clone -b release_1.3 --single-branch https://github.com/StephenGss/PAL.git
# clone polycraft_tufts
WORKDIR ${CODE}
RUN git clone -b master --single-branch git@github.com:tufts-ai-robotics-group/polycraft_tufts.git
# clone ADE
WORKDIR ${CODE}
RUN git clone -b polycraft-v1 --single-branch ssh://git@hrilab.tufts.edu:22222/ade/ade.git
# remove SSH key
RUN rm /root/.ssh/id_rsa

