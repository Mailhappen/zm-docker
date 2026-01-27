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

