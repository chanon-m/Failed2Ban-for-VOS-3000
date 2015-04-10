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

* Format for the whitelist

####_whitelist.ini_
```
ip1
ip2

```

* Create a crontab job on your server

If you want Failed2Ban3000.pl to run every 5 minutes, you should code the time as:

```

# crontab -e

*/5 * * * *      /etc/Failed2Ban3000.pl >> /var/log/failed2ban3000.log&

```

##TIP - Set QOS in CentOS

* Add new rules in iptables (Please make sure your switchhub doesn't remove dscp value)

```

#Setting DSCP
# tos_sip=cs3, tos_audio=ef, tos_video=af41
*mangle
-A OUTPUT -p udp -m udp --sport 5060 -j DSCP --set-dscp-class cs3
-A OUTPUT -p udp -m udp --dport 5060 -j DSCP --set-dscp-class cs3
-A OUTPUT -p udp -m udp --sport 10000:30000 -j DSCP --set-dscp-class ef
COMMIT

```

* Restart and monitor 

```

# service iptables restart
# iptables -t mangle -nvL

```
