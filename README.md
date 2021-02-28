# barcode_to_sun_addresses.pl
Script to convert from Sun Microsystems SPARCstation NVRAM 4-character barcodes to MAC, HostID, Serial # for SPARCstation SLC, ELC, and LX models.  May work with other later SPARCstations as well (e.g. Voyager).

## Version
Version 0.1.0, released on February 28, 2021

## References
Some other sources of information about these barcodes:

* C program to do basically the same thing: https://github.com/linkslice/slccodes
* Discussion on the NetBSD mailing list about these codes: http://mail-index.netbsd.org/port-sparc/2001/09/04/0003.html
* The Sun NVRAM FAQ: http://www.menet.umn.edu/~bob/FAQ/sun-nvram-hostid.faq
