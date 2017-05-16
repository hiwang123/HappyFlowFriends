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

table table_drop {
    actions {
        action_drop;
    }
}

action action_drop() {
    drop();
}

action action_remove_header(){
    remove_header(checker);
}

table table_remove_header {
    actions {
        action_remove_header;
    }

}
