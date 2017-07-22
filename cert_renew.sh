#!/bin/bash

servername=$(hostname -f)

servicecheck=($(/sbin/runuser -l root -c "/usr/bin/certbot renew |egrep -in 'not yet due for renewal'" ;))
if [[ $? != 0 ]] ;then
       echo "exit" && exit;
       else
        echo "Continue with the Certificate renewal";
  fi

echo "killing Zimbra proccesses"
/sbin/runuser -l zimbra -c '/opt/zimbra/bin/zmproxyctl stop'
/sbin/runuser -l zimbra -c '/opt/zimbra/bin/zmmailboxdctl stop'

##### initiate cert renew ######
echo "imitate cert renew"
/usr/bin/certbot renew

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
