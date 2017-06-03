#include "tables.p4"

control ingress {
   if (standard_metadata.ingress_port != 1) { // from proxy to verifier
       apply(table_forward_ahead);
   } else { // from verifier to proxy
       if (ethernet.etherType == ETHERTYPE_IPV4)
           apply(table_forward_back_ipv4);
       else if (ethernet.etherType == ETHERTYPE_ARP_IPV4)
           apply(table_forward_back_arp_ipv4);
       else 
       	   apply(table_drop); // for now, don't care
   }
}

control egress {
    // from proxy to verifier
    if(standard_metadata.egress_port == 1 and ethernet.etherType == ETHERTYPE_IPV4) {
        apply(table_add_header);
    }
}
