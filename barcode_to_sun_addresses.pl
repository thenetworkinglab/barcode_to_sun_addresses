#!/usr/bin/perl

use warnings qw(all);

use Getopt::Long;
use Pod::Usage;
use POSIX;

=pod 

=head1 SYNOPSIS

    barcode_to_sun_addresses.pl --machine_type=machine_type --barcode=barcode

=head1 DESCRIPTION

Converts from a 4-character barcode on an older Sun IDPROM chip into 
a serial #, hostid, and ethernet address. You need to know the Sun 'machine type':

Machine type

   Code      |  Machine Description
-------------+-----------------------------
    01       |  2/1x0
    02       |  2/50
    11       |  3/160
    12       |  3/50
    13       |  3/2x0
    14       |  3/110
    17       |  3/60
    18       |  3/e
    21       |  4/2x0
    22       |  4/1x0
    23       |  4/3x0
    24       |  4/4x0
    31       |  386i/150 or 386i/250
    41       |  3/4x0
    42       |  3/80
    51       |  SPARCstation 1   (4/60)
    52       |  SPARCstation IPC (4/40)
    53       |  SPARCstation 1+  (4/65)
    54       |  SPARCstation SLC (4/20)
    55       |  SPARCstation 2   (4/75)
    56       |  SPARCstation ELC (4/25)
    57       |  SPARCstation IPX (4/50)
    61       |  4/e
    71       |  4/6x0   (670)
    72       |  SPARCstation 10,20
    80       |  SPARCclassic, LX, SPARC 5, SPARC 4, SS1000, Voyager, and Ultra 1
    83       |  Later workstations

e.g. if you were going to run this for a SPARCstation 1 with a barcode of 'JET2', you'd use:

    barcode_to_sun_addresses.pl --machine_type=51 --barcode=JET2

=cut

# Deal with the command line arguments
GetOptions(
    'help'          => \my $help,
    'machine_type=s'    => \my $machine_type,
    'barcode=s'    => \my $barcode
) or pod2usage(q(-verbose) => 1);
pod2usage(q(-verbose) => 2) if $help;

# Some more variables we should declare
my $hostid;
my $mac;
my $serial;
my $barcode_numeric;

# Convert the barcode to its numeric equivalent
$barcode_numeric = strtol($barcode, 36);

# Create a serial #
$serial = $barcode_numeric - 0xAA8C0;

# Create a MAC address
$mac = $barcode_numeric - 0x82DC0;
# Or we can add 0x27b00 to the serial to get the mac? (from: http://mail-index.netbsd.org/port-sparc/2001/09/04/0003.html)
# Or on the ELC, the offset might be 0x77b00 (from: http://mail-index.netbsd.org/port-sparc/2001/09/04/0002.html)
# So, maybe there are different offsets for different machines?
#$mac = $serial + 0x27b00;
#$mac = $serial + 0x77b00;

# Create a hostid
# First, create a fake hex value to add to the serial:
$machine_type = "0x" . $machine_type . "000000";
# Now, convert it to a format we can add to the serial #: 
$machine_type = oct($machine_type) if $machine_type =~ /^0/;
$hostid = $machine_type + $serial;

# Be able to print the MAC address:
# First, add the standard old Sun OUI:
$mac_address[0] = 80;
$mac_address[1] = 0;
$mac_address[2] = 20;

# Next, parse out the host portion; we use substr() in reverse
# as negative serials cause a problem if we don't
$mac_address[3] = substr(sprintf("%06X", $mac), -6, 2);
$mac_address[4] = substr(sprintf("%06X", $mac), -4, 2);
$mac_address[5] = substr(sprintf("%06X", $mac), -2);
my $mac_string = join(":",@mac_address);

# Print our variables
print "IDPROM Barcode was: $barcode\n";
print "Serial # in hex is: " . sprintf("%X", $serial) . "\n";
print "Serial # in decimal is: $serial\n";
print "Ethernet MAC address is: $mac_string\n";
print "Host ID is: " . sprintf("%X", $hostid) . "\n";
