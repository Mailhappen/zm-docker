# Can be set via build-arg
ARG ZIMBRA_IMAGE=yeak/zimbra-aio
ARG VERSION=10.1.15.p1

FROM ${ZIMBRA_IMAGE}:${VERSION}

# Add Maldua-2FA
RUN cd /tmp \
  && curl -LO https://github.com/maldua-suite/zimbra-maldua-2fa/releases/download/v0.9.5/zimbra-maldua-2fa_0.9.5.tar.gz \
  && tar xf zimbra-maldua-2fa_0.9.5.tar.gz \
  && cd zimbra-maldua-2fa_0.9.5 \
  && sed -i '/zmzimletctl/d' ./install.sh \
  && ./install.sh \
  && install -o zimbra -g zimbra -m 644 com_btactic_twofactorauth_admin.zip /opt/zimbra/zimlets/ \
  && cd .. \
  && rm -rf /tmp/zimbra-maldua-2fa_0.9.5*

RUN mkdir /upgrade && /usr/bin/tar cf - \
  /opt/zimbra/conf /opt/zimbra/common/conf \
  /opt/zimbra/data /opt/zimbra/jetty_base/etc \
  /opt/zimbra/jetty_base/modules \
  | tar -C /upgrade -xf -

COPY supervisor/ /etc/supervisor/
