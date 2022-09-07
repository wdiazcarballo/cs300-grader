FROM ubuntu:18.04


RUN DEBIAN_FRONTEND=noninteractive apt-get update -y; apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive TZ=Asia/UTC apt-get -y install tzdata

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential openjdk-8-jdk-headless fp-compiler postgresql postgresql-client python3.6 cppreference-doc-en-html cgroup-lite libcap-dev zip python3-pip

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install nginx-full python2.7 php7.2-cli php7.2-fpm phppgadmin wget

RUN wget https://github.com/cms-dev/cms/releases/download/v1.4.rc1/v1.4.rc1.tar.gz
RUN tar xf v1.4.rc1.tar.gz
