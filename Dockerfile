# testImage

#FROM tomcat:8.5.15-jre8-alpine
#FROM openshift/base-centos7
FROM openjdk:8u171 

# TODO: Put the maintainer name in the image metadata
MAINTAINER Flannon <flannon@nyu.edu>

ENV HOME=/opt/app-root

RUN mkdir -p ${HOME} && \
    [[ $(grep default /etc/passwd) ]] || \
        useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
        -c "Default Application User" default

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0
ENV TESTER=test

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Test Platform for building oc images" \
      io.k8s.display-name="builder 0.0.1" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,0.0.1,test" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" 
      #io.openshift.s2i.scripts-url="image://${HOME}/s2i/bin"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
RUN yum install -y epel-release && \
    yum install -y python34 python34-devel python34-pip && \
    yum clean all -y

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i /usr/libexec/s2i
COPY ./init.sh ${HOME}/init.sh





# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root
#
#RUN chown -R 1001:0 /opt/app-root && \
#    find ${HOME} -type d -exec chmod g+ws {} \;
RUN chown -R 1001:0 /opt/app-root 

#WORKDIR ${HOME}

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
# EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/bin/run"]
#CMD ["/opt/app-root/run"]
