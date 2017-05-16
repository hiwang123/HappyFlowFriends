#!/usr/bin/env python
from mininet.net import Mininet, VERSION
from mininet.log import setLogLevel, info, debug
from mininet.cli import CLI
from distutils.version import StrictVersion
from p4_mininet import P4Switch, P4Host
from time import sleep
import sys

'''
h1 0 -- 0 s1 1 -------- 0 s2 1 ---- 0 h2
[   proxy  ]           [router]   [server]
'''

SW_PATH='/home/hiwang123/p4/behavioral-model/targets/simple_switch/simple_switch'
PROXY_JSON_PATH='/home/hiwang123/p4/zzcdn/proxy.json'
ROUTER_JSON_PATH='/home/hiwang123/p4/zzcdn/router.json'

def setup():
    net = Mininet(controller = None, autoSetMacs=True, autoStaticArp=True)
    h1 = net.addHost('h1') #proxy
    h2 = net.addHost('h2') #server
    
    s1 = net.addSwitch('s1', cls = P4Switch, sw_path=SW_PATH, json_path=PROXY_JSON_PATH, thrift_port=9091)
    s2 = net.addSwitch('s2', cls = P4Switch, sw_path=SW_PATH, json_path=ROUTER_JSON_PATH, thrift_port=9092)
    
    net.addLink(s1, h1, port1=0, port2=0)
    net.addLink(s1, s2, port1=1, port2=0)
    net.addLink(s2, h2, port1=1, port2=0)
    
    net.start()
    CLI(net)
    net.stop()

if __name__ == '__main__':
    setup()
