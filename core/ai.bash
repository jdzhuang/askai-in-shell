# >>> ai >>>
prompt_general='你是一个通用的智能助手。可以借助命令行工具，执行复杂任务。'
prompt_commander='你是一个'$(uname -s)'命令行工具(环境信息: '$(uname -a)')，只会回复命令行的操作命令(不需要过多解释, 至多用`#`在代码间做简要备注)，任何时候，都要避免使用markdown格式的代码包装，直接输出可运行代码。我需要凭借你输出的内容，不做任何加工直接进入到管道运行环节。如果命令可写成一行，就要注意用`;`做好隔断，以免语法错误。如果命令须分多行，则需要补上首行的执行器`#!/usr/bin/env bash`。对于多行的对象尽量用循环迭代，保持代码简洁。'
payload_template='{ "messages": [ { "content": $prompt, "role": "system" }, { "content": $msg, "role": "user" }], "model": $model, "max_tokens": 2048, "stop": null, "stream": false, "stream_options": null, "temperature": 0.9, "top_p": 1, "logprobs": false, "top_logprobs": null}'

pipe_for_ai(){
    local msg=$( while IFS= read -r line; do echo "$line"; done; )
    jsn_payload=$(jq -n --arg prompt "$prompt_commander" --arg model "$model" --arg msg "$msg" "$payload_template")
    rsp=$(curl -sL -X POST ${endpoint}'/chat/completions' \
        -H 'Content-Type: application/json' -H 'Accept: application/json' \
        -H 'Authorization: Bearer '${tkn} --data-raw "${jsn_payload}" \
    )
    #_log "response: $rsp"
    [ $? -ne 0 ] && { _err "request failed. (endpoint: $endpoint)."; exit 1; }
    echo "$rsp" | jq -r '.choices[0].message.content';
}

pipe_quote(){
    local quote=$( while IFS= read -r line; do echo "$line"; done; )
    echo -e "引用结果:\n"'```'"\n$quote\n"'```'
    echo -e "\n\n严格依据上述引用结果，"
}

ai_models(){
    rsp=$(curl -sL -X GET ${endpoint}'/models' -H 'Accept: application/json' -H 'Authorization: Bearer '${tkn}; );
    if [ $? -ne 0 ]; then _err "request failed. (endpoint: $endpoint)."; exit 1; fi
    echo "$rsp" | jq -r '.data[] | .id';
}

ai_balance(){
    rsp=$(curl -sL -X GET ${endpoint}'/user/balance' -H 'Accept: application/json' -H 'Authorization: Bearer '${tkn}; ); 
    if [ $? -ne 0 ]; then _err "request failed. (endpoint: $endpoint)."; exit 1; fi
    balance=$( echo "$rsp" | jq -r '.balance_infos[] | .total_balance'); currency=$( echo "$rsp" | jq -r '.balance_infos[] | .currency')
    echo "$balance $currency";
}

# <<< ai <<<

