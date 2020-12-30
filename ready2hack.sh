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
echo "${PLUS} Guaranteed Supported version"
echo "    [-] Ubuntu 20.04"
echo "${STAR} script start..."

echo "" > ./ready2hack.error.log

function execute {
    echo -n "    ${STAR} $1"
    $($2 1>/dev/null 2>>./ready2hack.error.log)
    if [ $? != 0 ]; then
        log $msg $FAIL
        echo "        ${POINT} Error. Check ready2hack.error.log"
        return -1
    else
        log $msg $OK
    fi
}

function install_by_apt {
    execute "Install by apt  : $1 ... " \
    "sudo apt-get -y install $1"
}

function install_by_gem {
    execute "Install by gem  : $1 ... " \
    "yes | sudo gem install $1"
}

function install_by_pip {
    execute "Install by pip$1 : $2 ... " \
    "sudo python$1 -m pip install $2"
}


################ STEP1 ################
is_execute_step 1
if [[ "${is_execute}" -eq 0 ]]; then
    echo "${PLUS} Step1. Initial setting (1/$TOTAL_STEP)"
    execute "32bit environment" "sudo dpkg --add-architecture i386"
    execute "apt repo add" "sudo add-apt-repository universe"
    execute "apt update" "sudo apt-get update 1>/dev/null"
    echo "  [complete] ===="
else
    echo "${PLUS} Step1 pass"
fi




################ STEP2 ################
is_execute_step 2
if [[ "${is_execute}" -eq 0 ]]; then
    echo "${PLUS} Step2. Install for essential environment (2/$TOTAL_STEP)"
    install_by_apt "libc6:i386 libncurses5:i386 libstdc++6:i386" 
    install_by_apt "vim"
    install_by_apt "curl"
    install_by_apt "ruby"
    install_by_apt "git"
    install_by_apt "docker"
    install_by_apt "python2.7 python3"
    install_by_apt "python2.7-dev python3-pip"

    # for python2 pip
    execute "pip2 (1/3)" "curl -O https://bootstrap.pypa.io/get-pip.py"
    execute "pip2 (2/3)" "sudo python2 get-pip.py" 
    execute "pip2 (3/3)" "rm get-pip.py"
else
    echo "${PLUS} Step2 pass"
fi




################ STEP3 ################
is_execute_step 3
if [[ "${is_execute}" -eq 0 ]]; then
    echo "${PLUS} Step3. Install about pwn (3/$TOTAL_STEP)"
    

    # for pwn
    execute "peda" "git clone https://github.com/longld/peda.git ${HOME}/peda"
    #execute "pwndbg (1/4)" "git clone https://github.com/pwndbg/pwndbg"
    #execute "pwndbg (2/4)" "cd pwndbg"
    #execute "pwndbg (3/4)" "./setup.sh"
    #execute "pwndbg (4/4)" "cd .."
    GDBINIT_SETTING="
    define peda
        source ~/peda/peda.py
    end
    "
    echo -e ${GDBINIT_SETTING//$'\n'/\\n} > ~/.gdbinit

    install_by_pip 2 "pwntools"
    install_by_apt "libcapstone-dev"
    install_by_pip 2 "ropgadget"
    #install_by_gem "one_gadget"
else
    echo "${PLUS} Step3 pass"
fi



################ STEP4 ################
is_execute_step 4
if [[ "${is_execute}" -eq 0 ]]; then
    echo "${PLUS} Step4. Install etc (4/$TOTAL_STEP)"
    # for development
    install_by_pip 3 "flask"
    install_by_apt "nodejs"
    install_by_apt "npm"

    # etc
    install_by_apt "binwalk"
else
    echo "${PLUS} Step4 pass"
fi

echo "${STAR} script finished"