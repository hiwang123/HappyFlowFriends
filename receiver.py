#!/usr/bin/env python
import sys
import struct
from scapy.all import sniff
from scapy.all import hexdump
from scapy.all import IP

def myprint(pkt):
    pkt.show()
    if IP in pkt:
    	hexdump(pkt)
    	pkt.show()
    	print pkt[IP].src, pkt[IP].dst, pkt[IP].proto

def main():
    sniff(iface = sys.argv[1], prn = lambda x: myprint(x))


if __name__ == '__main__':
    main()
