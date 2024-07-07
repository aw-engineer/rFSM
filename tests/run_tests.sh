#!/bin/bash
set -e
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )" 
OPTION_INTERP=lua
OPTION_CLEAN=1
TEST=`echo fsmtest_*`
#TEST="test_simple.lua"

export LUA_CPATH="/usr/lib/x86_64-linux-gnu/graphviz/lua/?.so"

function show_help() {
  echo "$0 [--clean]=$OPTION_CLEAN [-i | --interp]=\"${OPTION_INTERP}\""
  exit 0
}

LONGOPTS=clean:,interp:,help
OPTIONS=i:,h
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@") || exit 2
eval set -- "$PARSED"
while true; do
    case "$1" in
        --clean)
            OPTION_CLEAN="$2"
            shift 2
            ;;
	-i|--interp)
            OPTION_INTERP="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            shift 1
            ;;
        --)
            echo breaker
            shift
            break
            ;;
        *)
            echo error
            exit 3
            ;;
    esac
done

cd ${SCRIPT_DIR}
for interp in $OPTION_INTERP; do
    echo Using interpreter: $interp
    
    set +e
    which $interp
    [[ $? -ne 0 ]] && continue
    set -e
    for t in $TEST; do
        echo -e "\n\n*********************************** $interp $t ********************************************"
        $interp $t
    done
done

[[ $OPTION_CLEAN ]] && rm -vf *.png
