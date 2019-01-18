# Setup fzf
# ---------
if [[ ! "$PATH" == */home/otlin/.fzf/bin* ]]; then
  export PATH="$PATH:/home/otlin/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/otlin/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/otlin/.fzf/shell/key-bindings.bash"

