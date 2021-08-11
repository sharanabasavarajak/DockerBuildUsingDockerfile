ARG BASE_IMAGE_NAME
FROM ${BASE_IMAGE_NAME}

ENV WILDFLY_VER 24.0.1.Final
#ENV WILDFLY_SHA1
ENV JBOSS_HOME /opt/jboss/wildfly

USER root

RUN mkdir /var/log/sharanjboss
RUN chown jboss:jboss /var/log/sharanjboss

RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/${WILDFLY_VER}/wildfly-${WILDFLY_VER}.tar.gz \
    && tar xf wildfly-${WILDFLY_VER}.tar.gz \
    && mv $HOME/wildfly-${WILDFLY_VER} ${JBOSS_HOME} \
    && rm -rf wildfly-${WILDFLY_VER}.tar.gz \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME}
	
ENV LAUNCH_JBOSS_IN_BACKGROUND true
USER jboss
EXPOSE 8080

ENTRYPOINT ["${JBOSS_HOME}/bin/standalone.sh", "-b", "0.0.0.0"]	
