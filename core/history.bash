# >>> history >>>
_history_idx(){
    [ $# -lt 1 ] && { _log "_history_idx() need history-file";  return 1; }
    local msg=""; local idx=0; local dt=""; local idx_start=0; local idx_end=0;
    _h_out(){
        [ ${#msg} -gt 50 ] && msg="${msg:0:50}..."; echo "$dt $idx_start,$idx_end $msg "
    }
    while read line; do
        idx=$((idx+1))
        if [ "${#line}" -eq 22 ] && [ "${line:0:4}" == "## 2" ]; then
        #if [[ $line =~ ^##\ [0-9:T\-]{19}.* ]]; then #performance concerned. 
            [ $idx_start -gt 0 ] && _h_out
            dt="$(echo "$line" | cut -d' ' -f2)"; msg=""; idx_start=$((idx+1)); idx_end=$idx_start;
        else
            msg="$msg$(echo $line)"; idx_end=$idx
        fi
    done < $1
    [ -n "$msg" ] && _h_out;
}
_history() {
    [ $# -lt 1 ] && { _log "_history() need history-file";  return 1; }
    local selected=$(_history_idx $1 |tail -n 50 | sort -r | fzf)
    [ -z "$selected" ] && return 1
    idxs=$(echo "$selected" | cut -d' ' -f2)
    _log 'sed -n "'${idxs}'p" '$1
    sed -n "${idxs}p" $1 
}
to_history(){ 
    [ $# -lt 1 ] && { _log "to_history() need history-file";  return 1; }
    local msg=$(while IFS= read -r line; do echo "$line"; done;) 
    [ -n "$msg" ] && [ "history" != "$msg" ] && { echo -e "## $(date +'%Y-%m-%dT%H:%M:%S')\n$msg" >> $1; }
}
from_history(){ 
    [ $# -lt 1 ] && { _log "from_history() need history-file";  return 1; }
    [ ! -f $1 ] && touch $1; _history $1; 
}
# <<< history <<<
