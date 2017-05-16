#include "tables.p4"

#define check_key 0xdeadbeef

control ingress {
    apply(table_forward);
}

control egress {
    // from proxy to router
    if(standard_metadata.egress_port == 1) {
        apply(table_add_header);
    }
}
