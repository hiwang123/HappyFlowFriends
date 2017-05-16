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

#define check_key 0xdeadbeef

action action_add_header(){
    add_header(checker);
    modify_field(checker.val, check_key);
}

table table_add_header {
    actions {
        action_add_header;
    }

}
