FROM jdeathe/centos-ssh
RUN yum install -y yum-utils yum-plugin-ovl tar git curl bind-utils unzip wget \
 krb5-workstation initscripts && yum clean all
RUN curl -o /usr/bin/jq http://stedolan.github.io/jq/download/linux64/jq && chmod +x /usr/bin/jq

ENV JDK_ARTIFACT jdk-8u112-linux-x64.tar.gz
ENV JDK_VERSION jdk1.8.0_112

# install Ambari specified 1.7 jdk
RUN mkdir /usr/jdk64 && cd /usr/jdk64 && wget http://public-repo-1.hortonworks.com/ARTIFACTS/$JDK_ARTIFACT && \
    tar -xf $JDK_ARTIFACT && rm -f $JDK_ARTIFACT
ENV JAVA_HOME /usr/jdk64/$JDK_VERSION
ENV PATH $PATH:$JAVA_HOME/bin

# jce
ADD http://public-repo-1.hortonworks.com/ARTIFACTS/jce_policy-8.zip $JAVA_HOME/jre/lib/security/
RUN cd $JAVA_HOME/jre/lib/security && unzip jce_policy-8.zip && rm -f jce_policy-8.zip && mv UnlimitedJCEPolicyJDK8/*jar . && rm -rf jce_policy-8

ADD etc/yum.conf /etc/yum.conf

ENV PS1 "[\u@docker-ambari \W]# "
# add ambari repo
ADD ambari.repo /etc/yum.repos.d/

# initscripts (service wrapper for servicectl) is need othewise the Ambari is unable to start postgresql
RUN yum install -y ambari-agent && yum clean all

# add ambari shell to the image so new users don't need the 1GB java image
RUN curl -o /tmp/ambari-shell.jar https://s3-eu-west-1.amazonaws.com/maven.sequenceiq.com/releases/com/sequenceiq/ambari-shell/0.1.25/ambari-shell-0.1.25.jar
ENV PLUGIN_PATH /plugins
WORKDIR /tmp
