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

# config path here
SW_PATH='/home/hiwang123/p4/behavioral-model/targets/simple_switch/simple_switch'
MONITOR_JSON_PATH='monitor.json'
TOKEN_JSON_PATH='token.json'
VERIFIER_JSON_PATH='verifier.json'

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
        
        defaultIP0 = '192.168.1.1/24'
        R0 = self.addNode( 'r0', cls=LinuxRouter, ip=defaultIP0 )
        h0 = self.addHost('h0', ip='192.168.1.100/24', defaultRoute='via 192.168.1.1') # for clarity
        self.addLink(h0, R0, intfName2='r0-eth0', params2={ 'ip' : defaultIP0 })
        
        defaultIP1 = '172.16.1.1/24'
        R1 = self.addNode( 'r1', cls=LinuxRouter, ip=defaultIP1 )
        s4 = self.addSwitch('s4')
        c0 = self.addHost('c0', ip='172.16.1.100/24', defaultRoute='via 172.16.1.1')
        c1 = self.addHost('c1', ip='172.16.1.101/24', defaultRoute='via 172.16.1.1')
        c2 = self.addHost('c2', ip='172.16.1.102/24', defaultRoute='via 172.16.1.1')
        self.addLink(s4, c0)
        self.addLink(s4, c1)
        self.addLink(s4, c2)
        self.addLink(s4, R1, intfName2='r1-eth0', params2={ 'ip' : defaultIP1 })
        
        h11 = self.addHost('h11')
        h12 = self.addHost('h12')
        h2 = self.addHost('h2', ip='10.2.0.100/24', defaultRoute='via 10.2.0.1')
        c3 = self.addHost('c3', ip='10.3.0.100/24', defaultRoute='via 10.3.0.1')
        
        s0 = self.addSwitch('s0', cls = P4Switch, sw_path=SW_PATH, json_path=MONITOR_JSON_PATH, thrift_port=9090)
        s1 = self.addSwitch('s1', cls = P4Switch, sw_path=SW_PATH, json_path=TOKEN_JSON_PATH, thrift_port=9091)
        s2 = self.addSwitch('s2', cls = P4Switch, sw_path=SW_PATH, json_path=VERIFIER_JSON_PATH, thrift_port=9092)
        s3 = self.addSwitch('s3')
        
        self.addLink(s1, h11, port1=2, intfName2='h11-eth1')
        self.addLink(s1, h12, port1=3, intfName2='h12-eth1')
        self.addLink(s2, h2, port1=1)
        self.addLink(s3, c3)
        self.addLink(s0, h11, port1=2, intfName2='h11-eth0')
        self.addLink(s0, h12, port1=3, intfName2='h12-eth0')

        self.addLink(s1, R0, port1=1, intfName2='r0-eth1', params2={ 'ip' : '10.1.0.1/24' })
        self.addLink(s2, R0, port1=2, intfName2='r0-eth2', params2={ 'ip' : '10.2.0.1/24' })
        self.addLink(s3, R0, intfName2='r0-eth3', params2={ 'ip' : '10.3.0.1/24' })
        self.addLink(s0, R1, port1=1, intfName2='r1-eth1', params2={ 'ip' : '10.4.0.1/24' })
        
        
        

def toe_options(h, iface):
   toe_options=['rx','tx','sg','tso','ufo','gso','gro','rxvlan','txvlan']
   for option in toe_options:
        info( net[h].cmd( '/sbin/ethtool --offload '+ iface +' '+option+' off' ) )

def host_setting(h, iface1, iface2, ip1, ip2, gw1, gw2,target):
    info( net[h].cmd( 'ifconfig '+iface1+' '+ip1 ) )
    info( net[h].cmd( 'ifconfig '+iface2+' '+ip2 ) )
    info( net[h].cmd( 'route add default gw '+gw1) )
    info( net[h].cmd( 'ip route add '+target+' via '+ gw2) )
    toe_options(h, iface1)
    toe_options(h, iface2)
    

if __name__ == '__main__':
    setLogLevel( 'info' )
    topo = NetworkTopo()
    net = Mininet( topo=topo ) # controller for h3 switch and h0 switch
    net.start()
    info( '*** Settng host network option:\n' )
    host_setting('h11', 'h11-eth0', 'h11-eth1',
                 '10.4.0.100/24', '10.1.0.100/24', '10.4.0.1', '10.1.0.1', '10.2.0.0/24')
    host_setting('h12', 'h12-eth0', 'h12-eth1',
                 '10.4.0.101/24', '10.1.0.101/24', '10.4.0.1', '10.1.0.1', '10.2.0.0/24')
    net['r1'].cmd('arp -s 10.4.0.2 FF:FF:FF:FF:FF:FF')
    # c0 ping 10.4.0.2
    toe_options('h2', 'h2-eth0')
    toe_options('c0', 'c0-eth0')
    toe_options('c1', 'c1-eth0')
    toe_options('c2', 'c2-eth0')
    CLI( net )
    net.stop()

