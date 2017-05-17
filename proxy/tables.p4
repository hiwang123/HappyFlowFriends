#include "parser.p4"

action action_forward(out_port) {
    modify_field(standard_metadata.egress_spec, out_port);
}


table table_forward {
    reads {
        standard_metadata.ingress_port: exact;
    }
    actions {
        action_forward;
    }

}

action action_drop() {
    drop();
}

table table_drop {
    actions {
        action_drop;
    }
}

#define check_key 0xdeadbeef

action action_add_header() {
    add_header(checker);
    modify_field(checker.val, check_key);
}

table table_add_header {
    actions {
        action_add_header;
    }

}

// count min sketch increase count
action action_count_min_sketch_incr() {
    modify_field_with_hash_based_offset(my_metadata.hash_val0, 0, heavy_hitter_hash0, 16);
    modify_field_with_hash_based_offset(my_metadata.hash_val1, 0, heavy_hitter_hash1, 16);
    modify_field_with_hash_based_offset(my_metadata.hash_val2, 0, heavy_hitter_hash2, 16);
    
    register_read(my_metadata.count_val0, heavy_hitter_register0, my_metadata.hash_val0);
    register_read(my_metadata.count_val1, heavy_hitter_register1, my_metadata.hash_val1);
    register_read(my_metadata.count_val2, heavy_hitter_register2, my_metadata.hash_val2);
    
    add_to_field(my_metadata.count_val0, 1);
    add_to_field(my_metadata.count_val1, 1);
    add_to_field(my_metadata.count_val2, 1);
    
    register_write(heavy_hitter_register0, my_metadata.hash_val0, my_metadata.count_val0);
    register_write(heavy_hitter_register1, my_metadata.hash_val1, my_metadata.count_val1);
    register_write(heavy_hitter_register2, my_metadata.hash_val2, my_metadata.count_val2);
}

table table_count_min_sketch_incr{
    actions {
        action_count_min_sketch_incr;
    }
}


// count min sketch decrease count
action action_count_min_sketch_decr() {
    modify_field_with_hash_based_offset(my_metadata.hash_val0, 0, heavy_hitter_hash0, 16);
    modify_field_with_hash_based_offset(my_metadata.hash_val1, 0, heavy_hitter_hash1, 16);
    modify_field_with_hash_based_offset(my_metadata.hash_val2, 0, heavy_hitter_hash2, 16);
    
    register_read(my_metadata.count_val0, heavy_hitter_register0, my_metadata.hash_val0);
    register_read(my_metadata.count_val1, heavy_hitter_register1, my_metadata.hash_val1);
    register_read(my_metadata.count_val2, heavy_hitter_register2, my_metadata.hash_val2);
    
    add_to_field(my_metadata.count_val0, -2);
    add_to_field(my_metadata.count_val1, -2);
    add_to_field(my_metadata.count_val2, -2);
    
    register_write(heavy_hitter_register0, my_metadata.hash_val0, my_metadata.count_val0);
    register_write(heavy_hitter_register1, my_metadata.hash_val1, my_metadata.count_val1);
    register_write(heavy_hitter_register2, my_metadata.hash_val2, my_metadata.count_val2);
}

table table_count_min_sketch_decr{
    actions {
        action_count_min_sketch_decr;
    }
}

