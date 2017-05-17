#!/usr/bin/env python
import sys
import struct
from scapy.all import sniff
from scapy.all import hexdump
from scapy.all import IP

def myprint(pkt):
    #hexdump(pkt)
    #x.show()
    if IP in pkt:
    	print pkt[IP].src, pkt[IP].dst, pkt[IP].proto

def main():
    sniff(iface = "h2-eth0", prn = lambda x: myprint(x))


if __name__ == '__main__':
    main()
