FROM centos:7
LABEL maintainer='arkady.emelyanov@gmail.com'
LABEL description='HDP playground'

ARG HADOOP_USER='hadoop'
ENV JAVA_HOME=/usr/lib/jvm/jre \
	TERM=xterm \
	HADOOP_USER=${HADOOP_USER} \
	HADOOP_USER_HOME=/home/${HADOOP_USER}

# Java
RUN yum -y install java-1.8.0-openjdk-headless

# HDP repository
RUN curl -s "http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.4.0/hdp.repo" \
    -o /etc/yum.repos.d/hdp.repo

# HDP component installation
RUN yum -y install \
        hadoop-client \
        hadoop-hdfs \
        hadoop-hdfs-namenode \
        hadoop-hdfs-secondarynamenode \
        hadoop-hdfs-journalnode \
        hadoop-hdfs-zkfc \
        hadoop-yarn-nodemanager \
        hadoop-yarn-resourcemanager \
        hadoop-yarn-proxyserver \
        hadoop-yarn-timelineserver \
        hadoop-httpfs \
        hadoop-httpfs-server \
        hadoop \
        zookeeper

# Install mandatory tools
RUN yum -y install \
        net-tools which gettext \
        python-setuptools \
        openssh-clients openssh-server \
        nano vim mc \
    && easy_install supervisor \
    && mkdir -p /etc/supervisord.d \
    && mkdir -p /var/run \
    && mkdir -p /var/log

# Setup hadoop user
RUN useradd -g hadoop ${HADOOP_USER} -m -s /bin/bash \
    && mkdir "${HADOOP_USER_HOME}/.ssh" \
    && ssh-keygen -t rsa -f "${HADOOP_USER_HOME}/.ssh/id_rsa" -N "" -C "${HADOOP_USER}" \
    && cp -f ${HADOOP_USER_HOME}/.ssh/id_rsa.pub ${HADOOP_USER_HOME}/.ssh/authorized_keys \
    && chown ${HADOOP_USER}:${HADOOP_USER} -R ${HADOOP_USER_HOME}/.ssh \
    && chmod 0700 ${HADOOP_USER_HOME}/.ssh \
    && chmod 0600 ${HADOOP_USER_HOME}/.ssh/*

# Configure hadoop user
COPY supervisord.cfg /etc/supervisord.cfg
COPY entrypoint.sh /entrypoint.sh
COPY home/bash_profile ${HADOOP_USER_HOME}/.ssh/config
COPY home/bashrc ${HADOOP_USER_HOME}/.bashrc
COPY home/bash_profile ${HADOOP_USER_HOME}/.bash_profile

# Correct permissions
RUN chown root:root /entrypoint.sh \
    && chmod 0755 /entrypoint.sh \
    && touch ${HADOOP_USER_HOME}/.hushlogin \
    && chown ${HADOOP_USER}:${HADOOP_USER} -R ${HADOOP_USER_HOME}/.bashrc \
    && chown ${HADOOP_USER}:${HADOOP_USER} -R ${HADOOP_USER_HOME}/.bash_profile

VOLUME ["/storage"]
CMD ["/entrypoint.sh"]