#!/usr/bin/perl -w
use strict;
use DBI;
use File::Copy;

my $db = DBI->connect(
     "dbi:mysql:dbname=vos3000db",
     "root",
     "",
     { RaiseError => 1 },
) or die $DBI::errstr;

#Query illegal calls
my $query = $db->prepare("select DISTINCT callerip from e_cdr where endreason = '-9'");
$query->execute() or die "Couldn't execute statement!\n";

my $rows;
my $count=0;
my @heckip;
my $t = localtime;

while ($rows = $query->fetchrow_arrayref()) {
    $heckip[$count++] = @$rows[0];
}

$query->finish();
$db->disconnect();

if($count > 0) {
    #read and apply whitelist
    if(open(my $fh, '<',"/etc/failed2ban3000/whitelist.ini")) {
        my @whitelistlines=<$fh>;
        close $fh;
        foreach my $whitelist (@whitelistlines) {
            chomp $whitelist;
            for(my $j=0; $j < $count; $j++) {
                 if($whitelist =~ /$heckip[$j]/) {
                     $heckip[$j] = "";
                 }
            }

        }
    }
     
    #read iptables configuration
    open(my $fh, '<',"/etc/sysconfig/iptables") or die "Could not open file!\n";
    my @lines=<$fh>;
    close $fh;

    #find duplicated ip
    foreach my $line (@lines) {
       chomp $line;
       for(my $j=0; $j < $count; $j++) {
            my $str = "-A RH-Firewall-1-INPUT -s $heckip[$j] -j DROP";
            if($line =~ /$str/) {
              $heckip[$j] = "";
            }
       }
    }

    #add new iptables rules
    my $add_rule = 0;
    foreach my $ip (@heckip) {
       if($ip ne "") {
           my $returncode = system("/sbin/iptables -I RH-Firewall-1-INPUT 2 -s $ip -j DROP");
           if($returncode != 0) {
                print "$t Falied to add rules in iptables!\n";
           } else {
                $add_rule++;
                print "$t Bloacked IP Address : $ip\n";
           }
       }
    }

    #backup iptables file and save new iptables rules
    if($add_rule > 0) {
        move("/etc/sysconfig/iptables","/etc/sysconfig/iptables.$t") or die "Could not backup file!\n";
        my $returncode = system("/sbin/service iptables save");
        if($returncode != 0) {
            print "$t Falied to save iptables!\n";
        } else {
            print "$t iptables save!\n";
        }
    }
}
