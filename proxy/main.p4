#include "tables.p4"

#define check_key 0xdeadbeef
#define heavy_hitter_max 6

control ingress {
    apply(table_count_min_sketch_incr);
    if(my_metadata.count_val0 > heavy_hitter_max and
       my_metadata.count_val1 > heavy_hitter_max and
       my_metadata.count_val2 > heavy_hitter_max) {
        apply(table_count_min_sketch_decr);
        apply(table_drop);
    } else{
        apply(table_forward);
    }
}

control egress {
    // from proxy to router
    if(standard_metadata.egress_port == 1) {
        apply(table_add_header);
    }
}
