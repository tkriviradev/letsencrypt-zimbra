# letsencrypt-zimbra
Zimbra Letsencrypt Deploy and Certificate Renew

<p>These scripts are based on zimbra Official Letsencrypt deployment guide</p>
<p>LINK: https://wiki.zimbra.com/wiki/Installing_a_LetsEncrypt_SSL_Certificate</p>
<p>CA plus Root CA</p>
<p>LINK: https://www.identrust.com/certificates/trustid/root-download-x3.html</p>

### Very important! All scripts are tested on zimbra 8.6 and Centos 7 ###

### How to use deploy and renew scripts ####
<p>1 Download all file from my repository to your /root/ directory </p>
<p>2 chmod +x on cert_renew.sh and cert_deploy.sh</p>
<p>3 Make sure you have downloaded CA plus Root CA file "ca_plus_root_ca"</p>

<p>4 run cert_deploy.sh (If you don't have certbot installed script will install it for you from repository)</p>
<p>5 after that you can add renewal script to crontab</p>
<p>5.1 30 2 * * 1 /root/cert_renew.sh >> /var/log/le-renew.log</p>




