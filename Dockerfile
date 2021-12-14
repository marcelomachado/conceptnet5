# Start from the official postgres image
FROM postgres

LABEL maintainer="mmachado@ibm.com"

LABEL description="This is custom Docker Image for Conceptnet 5."

ARG DEBIAN_FRONTEND=noninteractive

ENV POSTGRES_USER root
ENV POSTGRES_PASSWORD root
ENV POSTGRES_DB root

RUN apt update
RUN apt -y upgrade
RUN apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev -y
RUN apt install python3-pip python3-dev -y
RUN apt install libreadline-dev libffi-dev curl libbz2-dev libsqlite3-dev -y
RUN apt install libhdf5-dev libmecab-dev mecab-ipadic-utf8 liblzma-dev lzma -y
RUN apt install supervisor procps systemd tmux wget unzip git nano -y

COPY create-multiple-postgresql-databases.sh /docker-entrypoint-initdb.d/

COPY . /usr/src
WORKDIR /usr/src
RUN mkdir data

RUN pip install -U pip
RUN pip install wheel ipadic pytest PyLD language_data
RUN pip install -e .
RUN pip install -e '.[vectors]'
RUN pip install -e web

CMD ["docker-entrypoint.sh", "-c", "shared_buffers=1GB", "-c", "max_wal_size=2GB"]