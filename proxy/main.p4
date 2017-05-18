#include "tables.p4"

//microsecond, 3s
#define timestamp_window_max 3000000

control ingress {
    // init
    apply(table_count_min_sketch_init);
    
    // timestamp
    apply(table_get_last_timestamp);
    if(my_metadata.timestamp0 + timestamp_window_max < intrinsic_metadata.ingress_global_timestamp){
    	apply(table_register0_reset);
    }
    if(my_metadata.timestamp1 + timestamp_window_max < intrinsic_metadata.ingress_global_timestamp){
    	apply(table_register1_reset);
    }
    if(my_metadata.timestamp2 + timestamp_window_max < intrinsic_metadata.ingress_global_timestamp){
    	apply(table_register2_reset);
    }
    apply(table_update_timestamp);
    
    // process
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
