#!/usr/bin/env bash
WD=$(cd $(dirname $0) && pwd); cd $WD
source $WD/core/util.bash
askai_dir=$HOME/.askai

copy_dir() {
    local src_dir=$1; local dst_dir=$2;
    [ ! -d $dst_dir ] && { echo "$(c_green '✓ ') $(c_gray 'make directory' ) $dst_dir">&2; mkdir -p $dst_dir; }
    for f in $src_dir/*; do n=$(basename $f);
        [ ! -f $dst_dir/$n ] && { echo "$(c_green '✓ ') $(c_gray 'create new file') $dst_dir/$n">&2; }
        [ -f $dst_dir/$n ] && { echo "$(c_orange '✓ ') $(c_gray 'exists, overwrite') $dst_dir/$n">&2; }
        cp $f $dst_dir; 
    done
}

copy_file() {
    local src_file=$1; local dst_file=$2; local dst_dir=$(dirname $dst_file);
    [ ! -d $dst_dir ] && { echo "$(c_green '✓ ') $(c_gray 'make directory') $dst_dir">&2; mkdir -p $dst_dir; }
    [ ! -f $dst_file ] && { echo "$(c_green '✓ ') $(c_gray 'create new file') $dst_file">&2; }
    [ -f $dst_file ] && { echo "$(c_orange '✓ ') $(c_gray 'exists, overwrite') $dst_file">&2; }
    cp $src_file $dst_dir; 
}

copy_dir  core   $askai_dir/core
copy_dir  fc     $askai_dir/fc
copy_file askai  $askai_dir/bin/askai
chmod +x  $askai_dir/bin/askai

[ ! -f $askai_dir/config ] || confirm "$(c_red 'overwrite') $askai_dir/config" && cat > $askai_dir/config <<EOF
# >>>  deepseek (default) >>>
#DEEPSEEK_API_KEY=""
endpoint=""                            # default as https://api.deepseek.com
model=""                               # default as deepseek-coder
#model="deepseek-chat"
# <<<  deepseek (default) <<<

# >>> from github models >>>
#GITHUB_API_KEY=""
#endpoint="https://models.inference.ai.azure.com" 
#model="gpt-4o"                        # high-limit, OK
#model="gpt-4o-mini"                   # low-limit, OK
#model="Cohere-command-r"              # low-limit
#model="Cohere-command-r-plus"         # high-limit
#model="Cohere-command-r-08-2024"      # low-limit
#model="Cohere-command-r-plus-08-2024" # high-limit
#model="Meta-Llama-3-70B-Instruct"     # high-limit, OK
#model="Mistral-Nemo"                  # low-limit, BAD
# <<< from github models <<<

EOF

echo "  "$(c_gray "you may need to add the following code to '~/.bashrc' or '~/.zshrc'... ") >&2
echo "    $(c_yellow 'export PATH=$HOME/.askai/bin:$PATH') " >&2
echo  >&2
echo "  "$(c_gray "and reload your shell by 'source ~/.bashrc' or 'source ~/.zshrc'... ") >&2

