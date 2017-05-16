#include "tables.p4"

#define check_key 0xdeadbeef

control ingress {
    if(standard_metadata.ingress_port == 0) {
        if(checker.val != check_key) {
        	apply(table_drop);
        } else {
            apply(table_remove_header);
        	apply(table_forward);
        }
    } else {
        apply(table_forward);
    }
}

control egress {
}
