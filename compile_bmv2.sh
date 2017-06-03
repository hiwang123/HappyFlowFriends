#!/bin/bash
source env.sh
COMPILER=$P4C_BM_PATH/p4c_bm/__main__.py

if [ -f "monitor.json" ]; then
    rm monitor.json
fi

if [ -f "token.json" ]; then
    rm token.json
fi

if [ -f "verifier.json" ]; then
    rm router.json
fi

$COMPILER --json monitor.json monitor/main.p4
$COMPILER --json token.json token/main.p4
$COMPILER --json verifier.json verifier/main.p4
