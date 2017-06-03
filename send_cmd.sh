#!/bin/bash
source env.sh
monitor_json_file="monitor.json"
token_json_file="token.json"
verifier_json_file="verifier.json"

if [ -f "$monitor_json_file" ]
then
    # insert default rule for p4 switches
    $BMV2_PATH/tools/runtime_CLI.py --json $monitor_json_file --thrift-port 9090 < monitor_cmd.txt
else
    echo "$monitor_json_file not found."
fi

if [ -f "$token_json_file" ]
then
    # insert default rule for p4 switches
    $BMV2_PATH/tools/runtime_CLI.py --json $token_json_file --thrift-port 9091 < token_cmd.txt
else
    echo "$token_json_file not found."
fi


if [ -f "$verifier_json_file" ]
then
    # insert default rule for p4 switches
    $BMV2_PATH/tools/runtime_CLI.py --json $verifier_json_file --thrift-port 9092 < verifier_cmd.txt
else
    echo "$verifier_json_file not found."
fi
