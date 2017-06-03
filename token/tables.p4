#include "parser.p4"

action forward_ahead() {
    modify_field(standard_metadata.egress_spec, 1);
}


table table_forward_ahead {
    actions {
        forward_ahead;
    }

}

action forward_back_ipv4() {
	// host num is 2^n, modify egress port
    modify_field(standard_metadata.egress_spec, (ipv4.dstAddr&1) + 2); 
}


table table_forward_back_ipv4 {
    actions {
        forward_back_ipv4;
        
    }

}

action forward_back_arp_ipv4() {
	// host num is 2^n, modify egress port
    modify_field(standard_metadata.egress_spec, (arp_ipv4.dst_ip&1) + 2); 
}


table table_forward_back_arp_ipv4 {
    actions {
        forward_back_arp_ipv4;
        
    }

}

table table_drop {
    actions {
        action_drop;
    }
}

action action_drop() {
    drop();
}

#define check_key 0xdeadbeef

action action_add_header() {
    add_header(checker);
    modify_field(checker.val, check_key);
    modify_field(ipv4.totalLen, ipv4.totalLen + 4);
    modify_field_with_hash_based_offset(ipv4.hdrChecksum, 0, ipv4_new_hdrChecksum, 65536);
}

table table_add_header {
    actions {
        action_add_header;
    }

}


