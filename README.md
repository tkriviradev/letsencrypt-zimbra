# letsencrypt-zimbra
Zimbra Letsencrypt Deploy and Certificate Renew

These scripts are based on zimbra Official Letsencrypt deployment guide
LINK: https://wiki.zimbra.com/wiki/Installing_a_LetsEncrypt_SSL_Certificate
CA plus Root CA
LINK: https://www.identrust.com/certificates/trustid/root-download-x3.html

### Very important! All scripts are tested on zimbra 8.6 and Centos 7 ###

### How to use deploy and renew scripts ####
1 Download all file from my repository to your /root/ directory
2 chmod +x on cert_renew.sh and cert_deploy.sh
3 Make sure you have downloaded CA plus Root CA file "ca_plus_root_ca"

4 run cert_deploy.sh (If you don't have certbot installed script will install it for you from repository)
5 after that you can all renewal script to crontab
5.1 30 2 * * 1 /root/cert_renew.sh >> /var/log/le-renew.log




