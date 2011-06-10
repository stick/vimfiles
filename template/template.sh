#!/bin/sh
#
# $Id$

usage() {
    echo "Usage:"
    echo "$0 [OPTIONS]"
    echo "Uploads a tree to a channel"
    echo
    echo "  OPTIONS:"
    echo "    --help        display usage and exit"
    echo "    --db          upload to this database"
    echo
    echo "Example:"
    echo "  $0 --channel useless-i386-10.1 --user rhn_upload_1 --db user/pass@instance"
    exit $1
}

while true; do
    case "$1" in
        --help)
            usage 0
            ;;
        --db)
            case "$2" in
                "") echo "No parameter specified for --db"; break;;
                *)  DB=$2; shift 2;;
            esac;;
        --sources)
            SOURCES="1"; shift;;
        "") break;;
        *) echo "Unknown keywords $*"; usage 1;;
    esac
done

[ -z "$DB" ] && echo "Missing --db" && usage 1
