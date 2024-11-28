# >>> bunch-of-functions >>>
_log() { echo "  "$(c_dark "$(date +'%Y-%m-%dT%H:%M:%S') $@")>&2; }
_err() { echo "  "$(c_red "$(date +'%Y-%m-%dT%H:%M:%S') $@")>&2; }
c_red() { printf "\e[38;5;196m%s\e[0m" "$@"; }
c_orange() { printf "\e[38;5;208m%s\e[0m" "$@"; }
c_yellow() { printf "\e[38;5;226m%s\e[0m" "$@"; }
c_green() { printf "\e[38;5;82m%s\e[0m" "$@"; }
c_blue() { printf "\e[38;5;39m%s\e[0m" "$@"; }
c_gray() { printf "\e[38;5;245m%s\e[0m" "$@"; }
c_dark() { printf "\e[38;5;240m%s\e[0m" "$@"; }
confirm() { echo -n "$@ (y/N): ">&2; read -s -n 1 -r </dev/tty; [[ $REPLY =~ [Yy] ]] &&{ echo $(c_orange 'yes')>&2; return 0;}; echo $(c_orange 'no')>&2; return 1; }
# <<< bunch-of-functions <<<

