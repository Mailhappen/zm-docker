#!/bin/bash
set -x

[ -e ./config.txt ] || cp ./config-sample.txt ./config.txt

source ./config.txt

# this is volume because it has data inside
## container commit?
/var/spool/cron/zimbra
/etc/logrotate.d/zimbra
/etc/rsyslog.conf


        target: /opt/zimbra/.ssh
        target: /opt/zimbra/backup
        target: /opt/zimbra/common/conf
        target: /opt/zimbra/conf
        target: /opt/zimbra/data
        target: /opt/zimbra/db/data
        target: /opt/zimbra/index
        target: /opt/zimbra/redolog
        target: /opt/zimbra/ssl
        target: /opt/zimbra/store
        target: /opt/zimbra/zimlets-deployed

	target: /opt/zimbra/common/etc/java/
	target: /opt/zimbra/common/jetty_home/resources/
	target: /opt/zimbra/jetty_base/etc/
	target: /opt/zimbra/jetty_base/modules/
	target: /opt/zimbra/jetty_base/start.d/
	target: /opt/zimbra/log/
	target: /opt/zimbra/zmstat/
	target: /var/log/


docker run -d -it \
	--name mail.example.test \
	-h mail.example.test \
	-v mat-ssh:/opt/zimbra/.ssh \
	-v mat-backup:/opt/zimbra/backup \
	-v mat-common-conf:/opt/zimbra/common/conf \
	-v mat-conf:/opt/zimbra/conf \
	-v mat-data:/opt/zimbra/data \
	-v mat-db-data:/opt/zimbra/db/data \
	-v mat-index:/opt/zimbra/index \
        -v mat-jetty-etc:/opt/zimbra/jetty_base/etc/ \
        -v mat-jetty-modules:/opt/zimbra/jetty_base/modules/ \
        -v mat-jetty-start.d:/opt/zimbra/jetty_base/start.d/ \
	-v mat-log:/opt/zimbra/log \
	-v mat-redolog:/opt/zimbra/redolog \
	-v mat-ssl:/opt/zimbra/ssl \
	-v mat-store:/opt/zimbra/store \
	-v mat-zimlets-deployed:/opt/zimbra/zimlets-deployed \
	-v mat-zmstat:/opt/zimbra/zmstat \
	-v mat-syslog:/var/log \
	yeak/zimbra-aio:10.1.15.p1


prefix="$(echo ${HOSTNAME} | tr -d '.')"

vol_zimbra="${prefix}-zimbra"
vol_store="${prefix}-store"
vol_index="${prefix}-index"
vol_log="${prefix}-log"

exit
docker run -d -it \
	--name ${HOSTNAME} \
	-v $vol_zimbra:/opt/zimbra \
	-v $vol_store:/opt/zimbra/store \
	-v $vol_index:/opt/zimbra/index \
	-v $vol_log:/var/log \
	-h mail.example.test \
	yeak/zimbra-aio:10.1.15.p1

exit
[root@mail ~]# /opt/zimbra/libexec/zmsetup.pl

./run.sh -h

./run.sh configure [config]
./run.sh start
./run.sh stop

Need to keep
Copy into /opt/zimbra/backup every stop and start
/etc/rsyslog.conf
/etc/logrotate.d/zimbra
/var/spool/cron/zimbra

