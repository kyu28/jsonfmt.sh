#!/bin/sh
#
# jsonfmt.sh - beautiful print JSON

next_token() {
    while [ -n "$str" ]; do
        c="$(printf '%c' "$str")"
        [ "$c" != " " ] && break
        str="${str#?}"
    done
    echo "$c"
}

main() {
    while read -r line || [ -n "$line" ] ; do
        str="$str$line"
    done
    # strip all \n
    str="$(printf "%s\n" "$str")"
    indent=""
    while [ -n "$str" ]; do
        c="$(printf '%c' "$str")"
        str="${str#?}"
        case "$c" in
        '{'|'[')
            printf "%c" "$c"
            indent="$indent  "
            echo
            printf "$indent"
            ;;
        '}'|']')
            indent="${indent%??}"
            printf "$indent%c" "$c"
            [ "$(next_token "$str")" != "," ] && echo
            ;;
        '"')
            printf "%c" "$c"
            while [ -n "$str" ]; do
                c="$(printf '%c' "$str")"
                str="${str#?}"
                printf "%s" "$c"
                if [ "$c" = '\' ]; then
                    c="$(printf '%c' "$str")"
                    str="${str#?}"
                    printf "%c" "$c"
                    continue
                fi
                if [ "$c" = '"' ]; then
                    break
                fi
            done
            tok="$(next_token "str")"
            if [ "$tok" = ']' ] || [ "$tok" = "}" ]; then
                echo
            fi
            ;;
        ',')
            printf "%c" "$c"
            echo
            printf "$indent"
            ;;
        ':')
            printf "%c " "$c"
            ;;
        ' '|'	')
            continue
            ;;
        *)
            printf "%c" "$c"
            tok="$(next_token "str")"
            if [ "$tok" = ']' ] || [ "$tok" = "}" ]; then
                echo
            fi
            ;;
        esac
    done
}

(main)
