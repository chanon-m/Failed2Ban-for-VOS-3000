# Failed2Ban-for-VOS-3000
Avoided SIP attackers for VOS 3000 SoftSwitch

#Licensing Information: READ LICENSE

#Project source can be downloaded from
##https://github.com/chanon-m/Failed2Ban-for-VOS-3000.git

#Author & Contributor

Chanon Mingsuwan

Reported bugs can be sent to chanonm@live.com

#How to run file

* Download files in your server

```

# git clone https://github.com/chanon-m/Failed2Ban-for-VOS-3000.git

```

* Copy Failed2Ban3000.pl to your VOS3000 SoftSwitch in /etc

```

# cp ./Failed2Ban-for-VOS-3000/Failed2Ban3000.pl /etc

```

* Make a file executable  

```

# chmod 755 /etc/Failed2Ban3000.pl

```

* Copy whitelist file to /etc

```

# cp -r ./Failed2Ban-for-VOS-3000/etc/failed2ban3000 /etc

```

* Create a crontab job on your server

If you want Failed2Ban3000.pl to run every 5 minutes, you should code the time as:

```

# crontab -e

*/5 * * * *      /etc/Failed2Ban3000.pl >> /var/log/failed2ban3000.log&

```
