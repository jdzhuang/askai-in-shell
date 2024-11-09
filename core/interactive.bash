# >>> interactive >>>
_info() {
    echo "$(c_gray 'Loaded:   + ')"$(c_dark "$v_loaded") >&2
    echo "$(c_gray 'EndPoint: + ')"$(c_dark "$endpoint") >&2
    echo "$(c_gray 'Model:    + ')"$model >&2    
    echo "$(c_gray 'OS:       + ')"$(c_dark "$(uname -s)") >&2
    echo "$(c_gray 'MODE:     + ')$([ $pipemode -eq 1 ] && c_dark 'pipeline'; [ $pipemode -eq 0 ] && c_dark 'interactive'; [ -n "$usr_prompt" ] && c_orange ' (with prompt)';)" >&2
}
_help() {
    echo "$(c_gray '  ? / help                    →')"$(c_dark " show this help message") >&2
    echo "$(c_gray '  exit                        →')"$(c_dark " exit") >&2
    echo "$(c_gray '  :<MSG>                      →')"$(c_dark " query message for AI") >&2
    echo "$(c_gray '  cd <DIR>                    →')"$(c_dark " change workdir") >&2
    echo "$(c_gray '  ↑ / history                 →')"$(c_dark " show history and select") >&2
    echo "$(c_gray '  choose                      →')"$(c_dark " choose multiple from Quote") >&2
    echo "$(c_gray '  clear                       →')"$(c_dark " clear Quote") >&2
    echo "$(c_gray '  save [answer|result|quote]  →')"$(c_dark " save answer|result|quote") >&2
    echo "$(c_gray '  <COMMAND>                   →')"$(c_dark " run (bash) command") >&2
}
_need_exit() { [ -z "$1" ] || [[ $1 =~ exit.* ]]&& return 0; return 1; }
_need_help() { [ "$1" == "help" ] || [ "$1" == "?" ] || [ "$1" == "？" ] && return 0; return 1; }
_need_ai() { [[ $1 =~ ^\ *[:：].*$ ]] || [[ $1 =~ ^\ *[一-龥].*$ ]]  || [[ $1 =~ ^\ *\`.*$ ]] && return 0; return 1; }
_need_() { [[ $2 =~ ^$1.*$ ]] && return 0; return 1; }
_clear() { > $quote_f; quote=""; quote_wrap=""; bot_say; echo "Quote cleared."; }
_strip_answer() { local cmd=$(echo "$answer" | sed -e 's/^ *[:：] *//g' | sed -e 's/^ *```.*//g' | sed -e 's/`/'\''/g' ); answer="$cmd"; }
_exec_answer() { local wd="done"; local rtn=0; result=$( _log "executing..."; echo "Q='$quote_f';$defined_cmd; $answer" | bash )||{ wd="failed"; rtn=1; }; echo "$result" >&2; _log "$wd"; executed=1; return $rtn; }
_expand_dir() { local dir=$(echo "$@" | sed -e 's/^cd *//ig' | sed -e 's#~#$HOME#g';); eval "echo $dir"; }
_set_workdir() { local dir=$(_expand_dir "$@"); [ -d "$dir" ] && { workdir=$(cd "$dir" && pwd); return 0; } || { _log "'$dir' is not a dir, or does not exist."; return 1;} }
_save() { local objs=$(echo "$@" | sed -e 's/^save *//ig'); [ -z "$objs" ] && objs="answer result quote"; 
    for o in $objs; do [[ ":answer:result:quote:"  =~ .*:$o:.* ]] && { dst="askai.$(date +%Y%m%d_%H%M%S).$o.txt"; _log "saving $dst"; echo "${!o}" > $dst; }; done
}
_use_result() { echo "$result" > $quote_f; quote="$result"; bot_say; echo "$(c_gray 'Quote saved.')"; }
bot_say() { echo -n "$(c_blue 'Bot ')$(c_green '> ')" >&2; }
you_say() { 
    [ -n "$quote" ] && echo "$(c_yellow 'Quote:「')"${quote:0:60}"$(c_dark '...')$(c_yellow '」(len='${#quote}')')" >&2; 
    local len=${#workdir}; max=40; br=$((len-12)); display_wd="${workdir:0:$max}"; [ $len -gt $max ] && { display_wd="${workdir:0:12}...${workdir:$br:$len}"; } 
    echo "$(c_orange 'You @r'$round' ')$(c_green "$display_wd"'> ')$(c_gray '(end:"ctrl-D")') " >&2; 
}
# <<< interactive <<<

