Requirements
1. CentOS
2. VOS3000
3. Perl

Instruction
1. Upload Failed2Ban3000.pl to your VOS3000 SoftSwitch in /etc
2. Create a crontab job on your server
If you want Failed2Ban3000.pl to run every 5 minutes, you should code the time as:
05 * * * *      /etc/Failed2Ban3000.pl >> /var/log/failed2ban3000.log&
