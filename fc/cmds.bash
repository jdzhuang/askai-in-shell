# >>> path-and-env >>>
# PATH
export PATH=$HOME/bin:$PATH
# <<< path-and-env <<<

# 查看目录，显示详情
function ll() { ls --color=auto -lah $@; }
# 查看目录，并显示隐藏文件
function la() { ls -A $@; }
# 查看目录，$1=关键字
function l() { ls -F $@; }
# 查看天气情况 $1=城市
function weather() { curl -s wttr.in/$1; }

