#!/usr/bin/python

from scapy.all import hexdump
from scapy.all import rdpcap
from scapy.all import sendp
from scapy.all import IP
from time import sleep

def main():

    pkts = rdpcap("test2.pcap")
    
    for pkt in pkts:
        sendp(pkt, iface = "h1-eth0")
        #hexdump(pkt)
        print pkt[IP].src, pkt[IP].dst, pkt[IP].proto
        sleep(1)

if __name__ == '__main__':
    main()
