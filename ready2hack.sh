#!/bin/bash


################ ARGUMENT SET ################

help()
{
    echo "Useage : $0"
    echo "    -s [step number]   execute single step"
    echo "    -j [step number]   jump to step"
    echo "    -h                 help"
    echo "Step :"
    echo "    1. Initial setting"
    echo "    2. Install for essential environment"
    echo "    3. Install about pwn"
    echo "    4. Install etc"
    exit 0
}

ARG_STEP=0
ARG_JMP=0

while getopts s:j:h opt
do
    case $opt in
        s) ARG_STEP=$OPTARG
            ;;
        j) ARG_JMP=$OPTARG
            ;;
        h) help ;;
        *) break ;;
    esac
done

is_execute=0
function is_execute_step {
    is_execute=0
    if [[ $ARG_STEP -eq 0 ]] && [[ $ARG_JMP -le $1 ]]; then
        is_execute=0
    elif [[ $ARG_STEP -eq $1 ]]; then
        is_execute=0
    else
        is_execute=1
    fi
}


################ FONT COLOR SET ################

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
CEND=$(tput sgr0)

STAR="[${GREEN}*${CEND}]"
PLUS="[${BLUE}+${CEND}]"
POINT="[${RED}!${CEND}]"

OK="[${GREEN}OK${CEND}]"
FAIL="[${RED}FAIL${CEND}]"


################ MAIN ################

function log {
    message=$1
    status=$2
    #let col=$(tput cols)-${#message}-${#status}
    #echo -n "${message}"
    echo -e "${message}    ${status}"
    #printf "%${col}s\n" "$status"
}

function run {
    echo "${PLUS} $1"
    $($1 1>/dev/null 2>>./error.log)
    if [ $? != 0 ]; then
        log $msg $FAIL
        echo "        ${POINT} Error. Check ready2hack.error.log"
        return -1
    else
        log $msg $OK
    fi
}

TOTAL_STEP=4

sudo echo ""
echo "  ==================================="
echo "  ==                               =="
echo "  ==         Ready2hack.sh         =="
echo "  ==                               =="
echo "  ==           by g0pher           =="
echo "  ==    last update 20. 12. 30.    =="
echo "  ==                               =="
echo "  ==================================="
echo "${STAR} script start..."

echo "" > ./error.log

run "./scripts/basic.sh"
run "./scripts/exec32elf.sh"

run "./scripts/web/nodejs.sh"
run "./scripts/web/flask.sh"
run "./scripts/web/mysql.sh"
run "./scripts/web/redis.sh"
run "./scripts/web/sqlite.sh"

run "./scripts/pwn/pwntools.sh"
run "./scripts/pwn/ropgadget.sh"
run "./scripts/pwn/one_gadget.sh"
run "./scripts/pwn/gdb_tools.sh"

run "./scripts/vm/docker.sh"
run "./scripts/vm/qemu.sh"

run "./scripts/etc/binwalk.sh"
#run "./scripts/etc/ai.sh"


echo "${STAR} script finished"