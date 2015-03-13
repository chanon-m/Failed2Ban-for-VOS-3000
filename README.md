# Failed2Ban-for-VOS-3000
Avoided SIP attackers on VOS 3000 SoftSwitch

Instruction Guide
1. Upload failed2ban300.pl to your VOS3000 SoftSwitch in /etc
2. Create a crontab job on your server
If you want Failed2Ban300.pl to run every 5 minutes, you should code the time as:
05 * * * *      /etc/failed2ban3000.pl >> /var/log/failed2ban3000.log&
