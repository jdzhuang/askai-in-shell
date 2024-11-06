# >>> token >>>
key_index="deepseek:DEEPSEEK_API_KEY azure:GITHUB_API_KEY openai:OPENAI_API_KEY anthropic:ANTHROPIC_API_KEY";
init_token() {
    for idx in $key_index; do
        local ep=${idx%:*}; local name=${idx#*:}; 
        if [[ "$endpoint" =~ .*$ep.* ]]; then 
            local t=$(printf '%s' "${!name}"); echo "$t";
            [[ -z "$t" ]] && { _err "env '$name' not set."; exit 1; }
            break;
        fi
    done
}
# <<< token <<<


