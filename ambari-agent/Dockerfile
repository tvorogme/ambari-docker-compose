FROM centos:7
MAINTAINER HeadLabs

RUN yum install epel-release -y && yum clean all
RUN yum update -y && yum clean all

#Setting up systemd
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
ENTRYPOINT ["/usr/sbin/init"]

RUN yum install -y systemd* yum-utils yum-plugin-ovl tar git curl bind-utils unzip wget \
 openssh-server openssh-clients krb5-workstation initscripts \
 && yum clean all

RUN mkdir -p /root/.ssh/ && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMEmFEu1LnoQgxMODc9CkdYEBG7HuJnex4lkRsG3A4uhx4DrzmMYsXcjO1yd0iNcp5jYTHPs2L+xJpwTIQyfGeT1c6nIMBZ8ftnv/6O6hhI1o6qN0VkCNY43W/QLc+6QAm9ttYDdRVjqdzn/riUQUIGd5hE4qHnN3AEt9nKnTKsOm8jfFn9nNCTnz/McvRuQqGwhslnm1ysr6P59Z4B1AxL5KbHHjP5ObGQ07wVBq+7eWIARy9L5+e2bboptanBhTzDkRJPaplv2sMNOvQ5i/eY8V8bM+Zr6OU30brs/o6q7y4c9VqL5cd3J6aA3CePlzSSyK4nEwRcXPXYeF+K/GI2QrQef2Gu0pTB2LcW1Jn+mKCZeNQRHfRWk6ha3TU26VtT8VEdzln5E1WJTsOIuk8GhjUtOndnA+lgkCoNo1Gv1v/oRkTn5GtLbJpyCAfbMeRwioSXKF1DFofJu9JRfwIBnUCVNL7XmnPxt+z9YcOSgUcOwcSulvdgK53Ja3VTG8= tvorogme@archlinux" > /root/.ssh/authorized_keys
RUN systemctl enable sshd

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

RUN yum install -y  ambari-agent && yum clean all

# add a custom folder to the hadoop classpath
RUN mkdir -p /usr/lib/hadoop/lib
ENV HADOOP_CLASSPATH /data/jars/*:/usr/lib/hadoop/lib/*

# do not use the docker0 interface
#RUN sed -i "s/\"ifconfig\"/\"ifconfig eth0\"/" /usr/lib/python2.6/site-packages/ambari_agent/Facter.py

# Add jars from packer image

ADD init/ambari-agent.service /etc/systemd/system/ambari-agent.service
RUN systemctl enable ambari-agent

RUN echo DefaultEnvironment=\"JAVA_HOME=$JAVA_HOME\" \"HADOOP_CLASSPATH=$HADOOP_CLASSPATH\" >> /etc/systemd/system.conf
