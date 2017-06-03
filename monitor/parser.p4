#include "headers.p4"
#include "intrinsic.p4" 

parser start {
    return parse_ethernet;
}


#define ETHERTYPE_IPV4 0x0800
#define ETHERTYPE_ARP_IPV4 0x0806

parser parse_ethernet {
    extract(ethernet);
    return select(ethernet.etherType) {
        ETHERTYPE_IPV4 : parse_ipv4;
        ETHERTYPE_ARP_IPV4 : parse_arp_ipv4;
        default: ingress;
    }
}

parser parse_ipv4 {
    extract(ipv4);
    return ingress;
}

parser parse_arp_ipv4 {
    extract(arp_ipv4);
    return ingress;
}

field_list hash_fields { // ip 3 tuple
    ipv4.srcAddr;
    ipv4.dstAddr;
    ipv4.protocol;
}

field_list_calculation heavy_hitter_hash0 { // hash function 0
    input { 
        hash_fields;
    }
    algorithm : csum16;
    output_width : 16;
}

field_list_calculation heavy_hitter_hash1 { // hash function 1
    input { 
        hash_fields;
    }
    algorithm : crc16;
    output_width : 16;
}

field_list_calculation heavy_hitter_hash2 { // hash function 2
    input { 
        hash_fields;
    }
    algorithm : bmv2_hash;
    output_width : 16;
}


