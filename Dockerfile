# Can be set via build-arg
ARG BASE_OS=yeak/zimbra-aio
ARG VERSION=10.1.15.p1

FROM ${BASE_OS}:${VERSION}

RUN mkdir /upgrade && /usr/bin/tar cf - \
        /opt/zimbra/conf \
        /opt/zimbra/common/conf \
        /opt/zimbra/data \
        /opt/zimbra/jetty_base/etc \
        /opt/zimbra/jetty_base/modules \
        | tar -C /upgrade -xf -

COPY supervisor/ /etc/supervisor/
