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

# Hadoop component installation
# hadoop base
RUN yum -y install \
        hadoop \
        hadoop-client \
        zookeeper

# hdfs
RUN yum -y install \
        hadoop-hdfs \
        hadoop-hdfs-namenode \
        hadoop-hdfs-secondarynamenode \
        hadoop-hdfs-journalnode \
        hadoop-hdfs-zkfc

# yarn
RUN yum -y install \
        hadoop-yarn-nodemanager \
        hadoop-yarn-resourcemanager \
        hadoop-yarn-proxyserver \
        hadoop-yarn-timelineserver

# hbase
RUN yum -y install \
        hbase-master \
        hbase-regionserver \
        hbase-thrift

# Install mandatory tools
RUN yum -y install \
        bind-tools net-tools which gettext \
        python-setuptools \
        openssh-clients openssh-server \
        nano vim mc \
    && easy_install -q supervisor pip \
    && mkdir -p /etc/supervisord.d \
    && mkdir -p /var/run \
    && mkdir -p /var/log

# Setup development libraries: hdfs, hbase
RUN yum -y install gcc make python-devel bzip2 \
    && curl -L https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -o /root/installer.sh \
    && bash /root/installer.sh -p /usr/local/miniconda -b && rm /root/installer.sh \
    && /usr/local/miniconda/bin/conda install -y hdfs3 -c conda-forge \
    && pip install --no-cache happybase

# Setup hadoop user
RUN useradd -g hadoop ${HADOOP_USER} -m -s /bin/bash \
    && mkdir "${HADOOP_USER_HOME}/.ssh" \
    && ssh-keygen -t rsa -f "${HADOOP_USER_HOME}/.ssh/id_rsa" -N "" -C "${HADOOP_USER}" \
    && cp -f ${HADOOP_USER_HOME}/.ssh/id_rsa.pub ${HADOOP_USER_HOME}/.ssh/authorized_keys \
    && chown ${HADOOP_USER}:${HADOOP_USER} -R ${HADOOP_USER_HOME}/.ssh \
    && chmod 0700 ${HADOOP_USER_HOME}/.ssh \
    && chmod 0600 ${HADOOP_USER_HOME}/.ssh/*

# Configure services
COPY supervisord.cfg /etc/supervisord.cfg
COPY entrypoint.sh /entrypoint.sh
COPY home/ssh_config ${HADOOP_USER_HOME}/.ssh/config
COPY home/bashrc ${HADOOP_USER_HOME}/.bashrc
COPY home/bash_profile ${HADOOP_USER_HOME}/.bash_profile
COPY home/become ${HADOOP_USER_HOME}/.become

# Correct permissions
RUN chown root:root /entrypoint.sh \
    && chmod 0755 /entrypoint.sh \
    && chmod 0755 ${HADOOP_USER_HOME}/.become \
    && chmod 0600 ${HADOOP_USER_HOME}/.ssh/* \
    && chmod 0700 ${HADOOP_USER_HOME}/.ssh \
    && touch ${HADOOP_USER_HOME}/.hushlogin \
    && chown ${HADOOP_USER}:${HADOOP_USER} -R ${HADOOP_USER_HOME}

VOLUME ["/storage"]
CMD ["/entrypoint.sh"]
