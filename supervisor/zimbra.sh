#!/bin/bash
set -x

# Location to keep the config
install_history=/opt/zimbra/backup/install_history
config_zimbra=/opt/zimbra/backup/config.zimbra

genpassword() {
  /opt/zimbra/bin/zmjava com.zimbra.common.util.RandomPassword -l 8 10
}

create_config() {
  cat <<EOT > $1
CREATEADMIN="${ADMIN_USERNAME}@${DEFAULT_DOMAIN}"
CREATEADMINPASS="${ADMIN_PASSWORD}"
CREATEDOMAIN="${DEFAULT_DOMAIN}"
LDAPHOST="${LDAP_HOST:=$HOSTNAME}"
LDAPPORT="636"
LDAPROOTPASS="${LDAP_ROOT_PASS}"
LDAPADMINPASS="${LDAP_ADMIN_PASS}"
LDAPREPPASS="${LDAP_ADMIN_PASS}"
LDAPPOSTPASS="${LDAP_ADMIN_PASS}"
LDAPAMAVISPASS="${LDAP_ADMIN_PASS}"
ldap_nginx_password="${LDAP_ADMIN_PASS}"
ldap_bes_searcher_password="${LDAP_ADMIN_PASS}"
SMTPHOST="${SMTP_HOST:=$HOSTNAME}"
SMTPDEST="${ADMIN_USERNAME}@${DEFAULT_DOMAIN}"
SMTPSOURCE="${ADMIN_USERNAME}@${DEFAULT_DOMAIN}"
AVUSER="${ADMIN_USERNAME}@${DEFAULT_DOMAIN}"
AVDOMAIN="${DEFAULT_DOMAIN}"
TRAINSASPAM="spam@${DEFAULT_DOMAIN}"
TRAINSAHAM="ham@${DEFAULT_DOMAIN}"
VIRUSQUARANTINE="virus-quarantine@${DEFAULT_DOMAIN}"
VERSIONUPDATECHECKS="FALSE"
zimbraVersionCheckNotificationEmail="${ADMIN_USERNAME}@${DEFAULT_DOMAIN}"
zimbraVersionCheckNotificationEmailFrom="${ADMIN_USERNAME}@${DEFAULT_DOMAIN}"
ENABLEDEFAULTBACKUP="no"
zimbraBackupReportEmailRecipients="${ADMIN_USERNAME}@${DEFAULT_DOMAIN}"
zimbraBackupReportEmailSender="${ADMIN_USERNAME}@${DEFAULT_DOMAIN}"
LICENSEACTIVATIONOPTION="2"
ONLYOFFICEHOSTNAME="${ONLYOFFICE_HOST:=$HOSTNAME}"
ONLYOFFICESTANDALONE="yes"
zimbraPrefTimeZoneId="${TIME_ZONE:=Asia/Kuala_Lumpur}"
LDAPREPLICATIONTYPE="${LDAP_REPLICATION_TYPE:=master}"
LDAPSERVERID="${LDAP_SERVER_ID:=1}"
EOT
}

copy_new_files() {
  /usr/bin/rsync -av -u \
    /upgrade/opt/zimbra/conf/ /opt/zimbra/conf/ --exclude localconfig.xml
  /usr/bin/rsync -av -u \
    /upgrade/opt/zimbra/data/ /opt/zimbra/data/
  [[ -d /opt/zimbra/common/conf ]] && /usr/bin/rsync -av -u \
    /upgrade/opt/zimbra/common/conf/ /opt/zimbra/common/conf/
  [[ -d /opt/zimbra/jetty_base/etc ]] && /usr/bin/rsync -av -u \
    /upgrade/opt/zimbra/jetty_base/etc/ /opt/zimbra/jetty_base/etc/
  [[ -d /opt/zimbra/jetty_base/modules ]] && /usr/bin/rsync -av -u \
    /upgrade/opt/zimbra/jetty_base/modules/ /opt/zimbra/jetty_base/modules/
  [[ -d /opt/zimbra/license ]] && /usr/bin/rsync -av -u \
    /upgrade/opt/zimbra/license/ /opt/zimbra/license/
}

keep_config() {
    /usr/bin/cp -f /opt/zimbra/.install_history $install_history
    /usr/bin/cp -f `ls -1t /opt/zimbra/config.* | tail -1` $config_zimbra
}

# Set timezone
if [[ -f /usr/share/zoneinfo/${TIME_ZONE} ]]; then
  ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime
  echo ${TIME_ZONE} > /etc/timezone
fi

# Exit if maintenance
if [[ "${MAINTENANCE}" == 1 ]]; then
  echo "Maintenance Mode"
  exit 0
fi

# Start zimbra
if grep -q 'CONFIGURED END' $install_history 2>/dev/null; then

  echo "### CONFIGURED ###"

  # Check if the same or different image version is used
  ver=$(sed -nE 's/.*zimbra-core-([0-9.]+_.*)\.rpm$/\1/p' /opt/zimbra/.install_history | tail -1)
  if ! grep -q "zimbra-core-$ver" $install_history 2>/dev/null; then

    echo "### UPGRADE ###"

    # inform container new version is available
    cat /opt/zimbra/.install_history | sed 's/INSTALLED/UPGRADED/' >> $install_history
    /usr/bin/cp -f $install_history /opt/zimbra/.install_history
    # copy new files to our volume
    copy_new_files

    # run zmsetup.pl to perform upgrade
    /opt/zimbra/libexec/zmsetup.pl -c $config_zimbra

    # keep these
    keep_config
  else

    echo "### JUST STARTUP ###"

    /etc/init.d/zimbra start
    /opt/zimbra/libexec/zmsyslogsetup
  fi
else

  echo "### NEW SETUP ###"

  # generate a new set of LDAP password
  LDAP_ADMIN_PASS="$(genpassword)"
  LDAP_ROOT_PASS="$(genpassword)"
  CONFIG="/tmp/config.$$"
  create_config $CONFIG

  # run zmsetup.pl to configure zimbra
  /opt/zimbra/libexec/zmsetup.pl -c $CONFIG

  # admin password must change
  su - zimbra -c "zmprov modifyAccount ${ADMIN_USERNAME}@${DEFAULT_DOMAIN} zimbraPasswordMustChange TRUE"

  # keep these
  keep_config
fi


# Define the handler function for cleanup
_term() {
  echo "Stopping Zimbra..."
  /etc/init.d/zimbra stop
  exit 0
}

# Trap SIGTERM and call the _term function
trap _term SIGTERM

# Run a background process and wait for it, or just wait
sleep infinity &
wait $!
