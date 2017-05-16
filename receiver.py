#!/usr/bin/env python
import sys
import struct
from scapy.all import sniff
from scapy.all import hexdump

def myprint(x):
    hexdump(x)
    x.show()

def main():
    sniff(iface = "h2-eth0", prn = lambda x: myprint(x))


if __name__ == '__main__':
    main()
