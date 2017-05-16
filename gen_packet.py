#!/usr/bin/env python
import sys
import struct
from scapy.all import sniff
from scapy.all import hexdump
from scapy.all import wrpcap

def main():
    pkts = sniff(iface = "wlp2s0", filter="tcp or udp or icmp", count=4)
    wrpcap('test.pcap', pkts)
    for pkt in pkts:
    	print hexdump(pkt)


if __name__ == '__main__':
    main()
