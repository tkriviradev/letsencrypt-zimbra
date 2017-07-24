#!/bin/bash

servername=$(hostname -f)
getdomains="-d $servername -d mail.domain.com"
getemail="support@google.com"

yum install certbot -y

##########################

/sbin/runuser -l zimbra -c '/opt/zimbra/bin/zmproxyctl stop'
/sbin/runuser -l zimbra -c '/opt/zimbra/bin/zmmailboxdctl stop'

/usr/bin/certbot certonly --agree-tos --non-interactive --email $getemail --standalone $getdomains

##### fix directory issues #####
echo "fix directory issues"
rm -rf /opt/zimbra/ssl/letsencrypt/
mkdir /opt/zimbra/ssl/letsencrypt/

##### copy needed files to zimbra directory #####
echo "copy needed files to zimbra directory"
cp -nf /etc/letsencrypt/live/$servername/*.pem /opt/zimbra/ssl/letsencrypt/

##### modify chain.pem file #####
echo "modify chain.pem file"
cat /root/ca_plus_root_ca >> /opt/zimbra/ssl/letsencrypt/chain.pem

### Than to give zimbra rights to the directory ###
chown -R zimbra.zimbra /opt/zimbra/ssl/letsencrypt/*

### Now we have to verify the Certificate #####
echo "Now we have to verify the Certificate"
cd /opt/zimbra/ssl/letsencrypt/ && /opt/zimbra/bin/zmcertmgr verifycrt comm privkey.pem cert.pem chain.pem
cp -nf /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key

### Now let's install the Certificate #####
echo "we are installing the certificate"
cd /opt/zimbra/ssl/letsencrypt/ && /opt/zimbra/bin/zmcertmgr deploycrt comm cert.pem chain.pem

### Now let's Restart the Zimbra Server #####
echo "Server Restart"
/sbin/runuser -l zimbra -c '/opt/zimbra/bin/zmcontrol restart'

exit
