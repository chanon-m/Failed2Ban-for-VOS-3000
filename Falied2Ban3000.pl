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

while ($rows = $query->fetchrow_arrayref()) {
    $heckip[$count++] = @$rows[0];
}

$query->finish();
$db->disconnect();

if($count > 0) {
  #Read iptables configuration
  open(my $fh, '<',"/etc/sysconfig/iptables") or die "Could not open file!\n";
  my @lines=<$fh>;
  my $linenum = scalar(@lines) - 2;
  close $fh;

  #Backup iptables file
  my $t = localtime;
  move("/etc/sysconfig/iptables","/etc/sysconfig/iptables.$t") or die "Could not backup file!\n";

  #Update an iptables configuration file
  my $i=0;
  open($fh, '>',"/etc/sysconfig/iptables") or die "Could not open file!\n";
  foreach my $line (@lines) {

     for(my $j=0; $j < $count; $j++) {
         my $str = "-A RH-Firewall-1-INPUT -s $heckip[$j] -j DROP\n";
         if($line eq $str) {
           $heckip[$j]="";
         }
     }

     if($i == $linenum) {
        for(my $j=0; $j < $count; $j++) {
          if($heckip[$j] ne "") {
            #Update a rule in IPtables   
            print $fh "-A RH-Firewall-1-INPUT -s $heckip[$j] -j DROP\n";
            my $returncode = system("/sbin/iptables -I RH-Firewall-1-INPUT 2 -s $heckip[$j] -j DROP");
            if($returncode != 0) {
                print "Could not add $heckip[$j] in iptables rule!\n";
            } else {
                print "Bloacked IP Address : $heckip[$j] \n";          
            }
          }
        }
        print $fh $line;
     } else {
         print $fh $line;
     }
     $i++;
  }
}
