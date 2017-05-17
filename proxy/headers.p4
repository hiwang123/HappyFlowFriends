header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
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
header checker_t checker;

header_type my_metadata_t {
    fields {
        hash_val0: 16;
        hash_val1: 16;
        hash_val2: 16;
        count_val0: 16;
        count_val1: 16;
        count_val2: 16;
    }
}

header my_metadata_t my_metadata;

register heavy_hitter_register0 {
    width : 16;
    instance_count : 65536;
}

register heavy_hitter_register1 {
    width : 16;
    instance_count : 65536;
}

register heavy_hitter_register2 {
    width : 16;
    instance_count : 65536;
}



