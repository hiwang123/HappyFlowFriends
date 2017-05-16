#!/bin/bash
source env.sh
proxy_json_file="proxy.json"
router_json_file="router.json"

if [ -f "$proxy_json_file" ]
then
    # insert default rule for p4 switches
    $BMV2_PATH/tools/runtime_CLI.py --json $proxy_json_file --thrift-port 9091 < proxy_cmd.txt
else
    echo "$proxy_json_file not found."
fi


if [ -f "$router_json_file" ]
then
    # insert default rule for p4 switches
    $BMV2_PATH/tools/runtime_CLI.py --json $router_json_file --thrift-port 9092 < router_cmd.txt
else
    echo "$router_json_file not found."
fi
