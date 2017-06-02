#!/usr/bin/env python
from mininet.topo import Topo
from mininet.net import Mininet, VERSION
from mininet.node import Node
from mininet.log import setLogLevel, info, debug
from mininet.cli import CLI
from distutils.version import StrictVersion
from p4_mininet import P4Switch, P4Host
from time import sleep
import sys
import os

'''
         h3 0 -- 1 s3 2
                      |
                      | 
h1 0 -- 1 P4s1 2 ---- R ---- 2 P4s2 1 ---- 0 h2
[     proxy    ]               [router]    [server]
'''

# config path here
SW_PATH='/home/hiwang123/p4/behavioral-model/targets/simple_switch/simple_switch'
PROXY_JSON_PATH='proxy.json'
ROUTER_JSON_PATH='router.json'

class LinuxRouter( Node ):
    "A Node with IP forwarding enabled."

    def config( self, **params ):
        super( LinuxRouter, self).config( **params )
        # Enable forwarding on the router
        self.cmd( 'sysctl net.ipv4.ip_forward=1' )

    def terminate( self ):
        self.cmd( 'sysctl net.ipv4.ip_forward=0' )
        super( LinuxRouter, self ).terminate()

class NetworkTopo( Topo ):

    def build(self, **_opts):
        
        h0 = self.addHost('h0', ip='192.168.1.100/24', defaultRoute='via 192.168.1.1') # for clarity
        h1 = self.addHost('h1', ip='10.1.0.100/24', defaultRoute='via 10.1.0.1')
        h2 = self.addHost('h2', ip='10.2.0.100/24', defaultRoute='via 10.2.0.1')
        h3 = self.addHost('h3', ip='10.3.0.100/24', defaultRoute='via 10.3.0.1')
        
        s0 = self.addSwitch('s0')
        s1 = self.addSwitch('s1', cls = P4Switch, sw_path=SW_PATH, json_path=PROXY_JSON_PATH, thrift_port=9091)
        s2 = self.addSwitch('s2', cls = P4Switch, sw_path=SW_PATH, json_path=ROUTER_JSON_PATH, thrift_port=9092)
        s3 = self.addSwitch('s3')
        
        defaultIP = '192.168.1.1/24'
        R = self.addNode( 'r0', cls=LinuxRouter, ip=defaultIP )
        
        self.addLink(s0, h0, port1=1, port2=0)
        self.addLink(s1, h1, port1=1, port2=0)
        self.addLink(s2, h2, port1=1, port2=0)
        self.addLink(s3, h3, port1=1, port2=0)

        self.addLink(s0, R, port1=2, intfName2='r0-eth0', params2={ 'ip' : defaultIP }) # for clarity
        self.addLink(s1, R, port1=2, intfName2='r0-eth1', params2={ 'ip' : '10.1.0.1/24' })
        self.addLink(s2, R, port1=2, intfName2='r0-eth2', params2={ 'ip' : '10.2.0.1/24' })
        self.addLink(s3, R, port1=2, intfName2='r0-eth3', params2={ 'ip' : '10.3.0.1/24' })
        
def host_setting(h, iface):
    toe_options=['rx','tx','sg','tso','ufo','gso','gro','rxvlan','txvlan']
    for option in toe_options:
        info( net[h].cmd( '/sbin/ethtool --offload '+ iface +' '+option+' off' ) )

if __name__ == '__main__':
    setLogLevel( 'info' )
    topo = NetworkTopo()
    net = Mininet( topo=topo ) # controller for h3 switch and h0 switch
    net.start()
    info( '*** Routing Table on Router:\n' )
    info( net[ 'r0' ].cmd( 'route' ) )
    info( '*** Settng host network option:\n' )
    host_setting('h1', 'h1-eth0')
    host_setting('h2', 'h2-eth0')
    CLI( net )
    net.stop()

