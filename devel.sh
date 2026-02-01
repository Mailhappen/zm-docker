#!/bin/bash

source ./config.txt

HOSTNAME=mail.mailhappen.test

prefix=$(echo ${HOSTNAME} | tr -d '.')
cmd="docker run -it -d --name ${HOSTNAME} \
    -h ${HOSTNAME} \
    --env-file ./config.txt \
    -v ./data:/data \
    -v ${prefix}-ssh:/opt/zimbra/.ssh \
    -v ${prefix}-backup:/opt/zimbra/backup \
    -v ${prefix}-common-conf:/opt/zimbra/common/conf \
    -v ${prefix}-common-etc-java:/opt/zimbra/common/etc/java/ \
    -v ${prefix}-common-jetty_home-resources:/opt/zimbra/common/jetty_home/resources/ \
    -v ${prefix}-conf:/opt/zimbra/conf \
    -v ${prefix}-data:/opt/zimbra/data \
    -v ${prefix}-db-data:/opt/zimbra/db/data \
    -v ${prefix}-index:/opt/zimbra/index \
    -v ${prefix}-jetty_base-etc:/opt/zimbra/jetty_base/etc/ \
    -v ${prefix}-jetty_base-modules:/opt/zimbra/jetty_base/modules/ \
    -v ${prefix}-jetty_base-start.d:/opt/zimbra/jetty_base/start.d/ \
    -v ${prefix}-log:/opt/zimbra/log \
    -v ${prefix}-logger:/opt/zimbra/logger \
    -v ${prefix}-redolog:/opt/zimbra/redolog \
    -v ${prefix}-ssl:/opt/zimbra/ssl \
    -v ${prefix}-store:/opt/zimbra/store \
    -v ${prefix}-zimlets-deployed:/opt/zimbra/zimlets-deployed \
    -v ${prefix}-zmstat:/opt/zimbra/zmstat \
    -v ${prefix}-logrotate.d:/etc/logrotate.d \
    -v ${prefix}-logrotate:/var/lib/logrotate \
    -v ${prefix}-syslog:/var/log \
    -v ${prefix}-cron:/var/spool/cron \
    ${HOSTNAME}"

echo $cmd
#eval $cmd
