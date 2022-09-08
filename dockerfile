FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y; apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive TZ=Asia/UTC apt-get -y install tzdata

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential openjdk-8-jdk-headless fp-compiler postgresql postgresql-client python3.6 cppreference-doc-en-html cgroup-lite libcap-dev zip python3-pip

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install nginx-full python2.7 php7.2-cli php7.2-fpm phppgadmin wget apt-utils

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install locales-all
RUN DEBIAN_FRONTEND=noninteractive locale-gen

RUN sed -i '/th_TH.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG th_TH.UTF-8  
ENV LANGUAGE th_TH:th
ENV LC_ALL th_TH.UTF-8     

COPY ./cms /cms
RUN whoami
RUN cd /cms; python3 prerequisites.py -y --as-root install
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python3-setuptools \
python3-tornado python3-psycopg2 python3-sqlalchemy python3-psutil python3-netifaces \
python3-crypto  python3-six python3-bs4 python3-coverage python3-mock python3-requests \
python3-werkzeug python3-gevent python3-bcrypt python3-chardet patool \
python3-babel python3-xdg python3-future python3-jinja2

RUN  DEBIAN_FRONTEND=noninteractive apt-get install -y python3-yaml python3-sphinx python3-cups python3-pypdf2 screen

RUN cd /cms; python3 setup.py install

COPY ./configPostgres.sh /app/configPostgres.sh
COPY ./cms.conf /app/cms.conf

RUN cp /app/cms.conf /usr/local/etc/cms.conf
RUN /app/configPostgres.sh
RUN cd /cms; python3 prerequisites.py -y --as-root install
RUN /usr/bin/screen -S cmsLogService -d -m /bin/bash -c '/usr/local/bin/cmsLogService'
RUN /usr/bin/screen -S cmsResourceService -d -m /bin/bash -c '/usr/local/bin/cmsResourceService -a 1'
RUN update-rc.d postgresql enable


