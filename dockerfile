FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y; apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive TZ=Asia/UTC apt-get -y install tzdata

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential openjdk-8-jdk-headless fp-compiler postgresql postgresql-client python3.6 cppreference-doc-en-html cgroup-lite libcap-dev zip python3-pip

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install nginx-full python2.7 php7.2-cli php7.2-fpm phppgadmin wget

COPY ./cms /cms
RUN whoami
RUN cd /cms; python3 prerequisites.py -y --as-root install
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python3-setuptools \
python3-tornado python3-psycopg2 python3-sqlalchemy python3-psutil python3-netifaces \
python3-crypto  python3-six python3-bs4 python3-coverage python3-mock python3-requests \
python3-werkzeug python3-gevent python3-bcrypt python3-chardet patool \
python3-babel python3-xdg python3-future python3-jinja2

RUN  DEBIAN_FRONTEND=noninteractive apt-get install -y python3-yaml python3-sphinx python3-cups python3-pypdf2

RUN cd /cms; python3 setup.py install

COPY ./configPostgres.sh /app/configPostgres.sh
COPY ./cms.conf /app/cms.conf

RUN /app/configPostgres.sh
RUN cp /app/cms.conf /usr/local/etc/cms.conf
RUN cmsInitDB
