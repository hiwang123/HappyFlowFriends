#include "headers.p4"
#include "intrinsic.p4" 

parser start {
    return parse_ethernet;
}


#define ETHERTYPE_IPV4 0x0800
#define FAKE_IPV4_VER 0x0

parser parse_ethernet {
    extract(ethernet);
    return select(ethernet.etherType) {
        ETHERTYPE_IPV4 : parse_ipv4;
        default: ingress;
    }
}

parser parse_ipv4 {
    extract(ipv4);
    return select(ipv4.version) {
        FAKE_IPV4_VER : parse_checker; // hack(parse graph), otherwise will overwrite tcp part
        default: ingress;
    }
}

parser parse_checker {
    extract(checker);
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

field_list ipv4_checksum_list {
        ipv4.version;
        ipv4.ihl;
        ipv4.diffserv;
        ipv4.totalLen;
        ipv4.identification;
        ipv4.flags;
        ipv4.fragOffset;
        ipv4.ttl;
        ipv4.protocol;
        ipv4.srcAddr;
        ipv4.dstAddr;
}

field_list_calculation ipv4_new_hdrChecksum {
    input {
        ipv4_checksum_list;
    }
    algorithm : csum16;
    output_width : 16;
}

