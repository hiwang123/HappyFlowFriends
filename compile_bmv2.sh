#!/bin/bash
source env.sh
COMPILER=$P4C_BM_PATH/p4c_bm/__main__.py

if [ -f "proxy.json" ]; then
    rm proxy.json
fi

if [ -f "router.json" ]; then
    rm router.json
fi

$COMPILER --json proxy.json proxy/main.p4
$COMPILER --json router.json router/main.p4
