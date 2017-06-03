header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}

header_type arp_ipv4_t {
    fields {
    	ignore: 64;
        src_mac : 48;
        src_ip : 32;
        dst_mac : 48;
        dst_ip : 32;
    }
}

header_type ipv4_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        flags : 3;
        fragOffset : 13;
        ttl : 8;
        protocol : 8;
        hdrChecksum : 16;
        srcAddr : 32;
        dstAddr: 32;
    }
}

header_type checker_t {
    fields {
        val : 32;
    }
}

header ethernet_t ethernet;
header ipv4_t ipv4;
header arp_ipv4_t arp_ipv4;
header checker_t checker;

