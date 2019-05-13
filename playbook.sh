#!/usr/bin/env bash 

usage() {
  cat <<-EOF
  Usage: playbook.sh -i INVENTORY_FILE [-t TAG1,TAG2] [PLAYBOOK]
  Options:
    -h, --help           output help information
    -i, --inventory      provide inventory file
    -t, --tags           tags no spaces,comma-separated (optional)
  Commands:
    [PLAYBOOK]           playbook to run (default: site.yml)
EOF

}

abort() {
    echo
    echo "  $@" 1>&2
    echo
    exit 1
}

log () {
    echo 
    echo "  • $@"
}

required_vars() {

    [ -z $HOSTS ] && abort "-i INVENTORY_FILE was not provided, aborting deploy..."
    start=$(date +%s)

}

role_exec() {
    local HOSTS=${1:+"-i $1"}
    [ -z $2 ] || local TAGS=${2:+"-t $2"}
    local PLAYBOOK=${3}

    log " ---------------------------- PLAYBOOK(S) $PLAYBOOKS execution ----------------------------"
    log "$ANSIBLE $HOSTS $TAGS $PLAYBOOK $args"
    set +x
    $ANSIBLE $HOSTS $TAGS $PLAYBOOK $args
    [ $? != 0 ] && abort "Playbook run was not successful."
    set +x
}


start=$(date +%s)

CWD="${PWD}"
ANSIBLE=$(command -v ansible-playbook)
ANSIBLEGALAXY=$(command -v ansible-galaxy)

[ -z "$ANSIBLE" ] && abort "Ansible is not installed"
[ -z "$ANSIBLEGALAXY" ] && abort "Ansible is not installed"

log "$ANSIBLE"
echo 

[ -z "$1" ] && usage && exit

set +x
while true; do
    case $1 in
        -h|--help) usage; exit ;;
        -i|--inventory) ([[ $2 == -* ]] || [ -z "$2" ]) && abort "$1 <- declared but not defined..." || HOSTS=${2:-hosts}; shift 2;;
        -t|--tags)      ([[ $2 == -* ]] || [ -z "$2" ]) && abort "$1 <- declared but not defined..." || TAGS="$2"; shift 2;;
        -*) args="${args##*( )} $1 $2"; shift 2;;
        tasks) 
            [ -z "$2" ] || { set -- $@ pull; shift; continue; }
            ansible-playbook -i $HOSTS --list-tasks --list-tags ${PLAYBOOK:-site.yml}
            break;;
        "") echo ---
            [ -f "${CWD}/requirements.yml" ] && ansible-galaxy install -r requirements.yml -f

            required_vars $@
            
            # Run PLAYBOOKS
            for playbook in ${PLAYBOOKS:-site.yml}; do 
                role_exec $HOSTS ${TAGS:-" "} $playbook $args
                done                
            break
        ;;
        *) 
           PLAYBOOKS="${PLAYBOOKS##*( )} $1"; shift;
        ;;
    esac
done
set +x

end=$(date +%s)

log "Playbook run time : $((end-start)) seconds"
set +x
