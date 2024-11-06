# >>> variables >>>
quote_f=$askai_dir/quote.$$; touch $quote_f; trap "rm -f $quote_f" EXIT 
history_f="$askai_dir/input.history"; 
defined_cmd='[ -e "'$askai_dir'/fc/cmds.bash" ] && for f in '$askai_dir'/fc/*.*sh;do source $f; done' # TODO a proper check
endpoint=${endpoint:-"https://api.deepseek.com"}; 
model=${model:-"deepseek-coder"}; 
workdir=${workdir:-"$(pwd)"};
answer=""; 
result=""; 
quote=""; 
executed=0; 
round=0; 
pipemode=0; 
usr_prompt="";
#
tkn=""; 
# <<< variables <<<


