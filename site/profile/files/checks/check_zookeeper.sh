#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

declare -a NODES
NODES=(ala-lpd-mesos ala-lpdfs01 yow-lpdfs01 pek-lpdfs01 ala-blade17)

NUM_LEADER=0
NUM_OBSERVER=0
NUM_FOLLOWER=0

function check_zoo_stats() {
    local STATS=
    STATS=$(echo -n stat | /bin/nc "$1" 2181)
    if echo "$STATS" | /bin/grep -q "Mode: leader"; then
        NUM_LEADER=$((NUM_LEADER + 1))
    elif echo "$STATS" | /bin/grep -q "Mode: follower"; then
        NUM_FOLLOWER=$((NUM_FOLLOWER + 1))
    elif echo "$STATS" | /bin/grep -q "Mode: observer"; then
        NUM_OBSERVER=$((NUM_OBSERVER + 1))
    fi
}

for node in "${NODES[@]}"; do
    check_zoo_stats $node
done

#echo "Leader: $NUM_LEADER"
#echo "Follower: $NUM_FOLLOWER"
#echo "Observers: $NUM_OBSERVER"

if [ "$NUM_LEADER" -lt "1" ]; then
    echo "CRITICAL: No Zookeeper leader"
    exit 2
fi

if [ "$NUM_FOLLOWER" -lt "2" ]; then
    echo "ZOOKEEPER WARNING: No Zookeeper redundancy L:$NUM_LEADER,F:$NUM_FOLLOWER,O:$NUM_OBSERVER"
    exit 1
fi

if [ "$NUM_OBSERVER" -lt "2" ]; then
    echo "ZOOKEEPER WARNING: Zookeeper observer down"
    exit 1
fi

echo "OK: Zookeeper Cluster Healthy: L:$NUM_LEADER,F:$NUM_FOLLOWER,O:$NUM_OBSERVER"
exit 0
