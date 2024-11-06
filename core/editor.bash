# >>> fine-editor >>>
one_line_editor_keywords=":cd:exit:clear:save:choose:history:help:"
function editor() { #fine-editor
    local pipe=/dev/stdin; local cnt=0; local i=0; [ -n "$1" ] && [ "$1" != "-" ]&& pipe=$1; [ "$pipe" == "/dev/tty" ] && i=1;
    set -o vi; bind '"\e[A": "history\n"'; while true; do 
        [ $i -eq 1 ] && echo -n "$(c_green '> ')">&2; read -e line;
        if [ $? -ne 0 ]; then echo -e "\033[K\033[1A">&2; break; fi; if [ -z "$line" ]; then continue; fi; 
        [ $i -eq 1 ] && echo -en "\033[K\033[1A">&2; echo "$(c_green '✓ ')$line">&2; echo "$line"; cnt=$((cnt+1)); 
        [ $cnt -eq 1 ] && { local lead_wd=${line%% *}; [[ "$one_line_editor_keywords" =~ .*:$lead_wd:.* ]] && break; }
    done < $pipe
    [ "$2" == "--mixed" ] && editor /dev/tty 
}
# <<< fine-editor <<<
