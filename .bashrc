[[ $- == *i* ]] || return 0

# ble.sh: fish-style autosuggestions + syntax highlighting (zsh-autosuggestions/zsh-syntax-highlighting equivalent)
[[ -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh --noattach

[[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]] && source /opt/homebrew/etc/profile.d/bash_completion.sh

shopt -s histappend checkwinsize autocd globstar
bind "set completion-ignore-case on"
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth:erasedups

# bira-style prompt
__git_branch() { local b; b=$(git symbolic-ref --short HEAD 2>/dev/null) || return; [[ -n $(git status --porcelain 2>/dev/null) ]] && printf ' ‹%s› ✗' "$b" || printf ' ‹%s› ✔' "$b"; }
PS1='╭─\[\e[1;32m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]\[\e[33m\]$(__git_branch)\[\e[0m\]\[\e[31m\]${__last_exit:+ $__last_exit ↵}\[\e[0m\]\n╰─\$ '

alias be='bundle exec'
alias brew-update='brew update && brew upgrade --no-ask && brew cleanup --prune=all'
alias docker-remove-stopped-containers='docker rm $(docker ps -aq --no-trunc -f status=exited)'
alias docker-remove-created-containers='docker rm $(docker ps -aq --no-trunc -f status=created)'
alias docker-remove-untagged-images='docker rmi $(docker images --quiet --filter "dangling=true")'
alias gall='gitk --all'
git-delete-merged-on-main() {
  local branches=$(git branch --merged | grep -v "^\s*\*\|\s*main$\|\s*master$")
  if [ -n "$branches" ]; then
    echo "$branches" | xargs git branch -d
  else
    echo "No merged branches to delete"
  fi
}
git-fetch-main() {
  local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -z "$current_branch" ]; then
    echo "Not on a branch (detached HEAD?). Aborting."
    return 1
  fi
  local stash_output=$(git stash --include-untracked)
  local stashed=false
  [[ "$stash_output" != "No local changes to save" ]] && stashed=true
  git checkout main
  git fetch
  git reset --hard origin/main
  git checkout "$current_branch"
  $stashed && git stash pop
}
git-copy-branch-name() {
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -z "$branch" ]; then
    echo "Not on a branch (detached HEAD?). Aborting."
    return 1
  fi
  echo -n "$branch" | pbcopy
  echo "Copied: $branch"
}
codex() {
  local gh_token
  gh_token="$(command gh auth token 2>/dev/null)" || return 1
  if [[ -z "$gh_token" ]]; then
    echo "gh is not authenticated" >&2
    return 1
  fi
  GH_TOKEN="$gh_token" command codex "$@"
}
codex-personal() {
  mkdir -p "$HOME/.codex-personal" || return 1
  CODEX_HOME="$HOME/.codex-personal" codex "$@"
}
alias gitlog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%aN>%Creset'"
alias l='ls'
alias ll='ls -lash'
alias npm-cleanup='npm dedupe && npm prune && npm install'
alias mine='/Applications/RubyMine.app/Contents/MacOS/rubymine'
claude-personal() {
  "$HOME/.claude/scripts/sync-claude-personal.sh" || echo "claude-personal: config sync failed" >&2
  CLAUDE_CONFIG_DIR="$HOME/.claude-personal" command claude "$@"
}
alias opencode-personal='XDG_DATA_HOME="$HOME/.local/share/opencode-personal-data" command opencode'
opencode2-personal() {
  local -a args=("$@")
  if (( $# == 0 )) || [[ "$1" == -* || -d "$1" ]]; then
    args=(--standalone "$@")
  fi
  XDG_CONFIG_HOME="$HOME/.config/opencode2-personal" \
    XDG_DATA_HOME="$HOME/.local/share/opencode2-personal" \
    XDG_CACHE_HOME="$HOME/.cache/opencode2-personal" \
    XDG_STATE_HOME="$HOME/.local/state/opencode2-personal" \
    command opencode2 "${args[@]}"
}
alias shrug="echo \"\\\`¯\_(ツ)_/¯\\\`\" | pbcopy"

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR="code --wait"


export PATH="$HOME/.asdf/shims:$HOME/.asdf:$PATH"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH:$HOME/.lmstudio/bin"

eval "$(direnv hook bash)"
# Runs first so $? is still the last command's status.
PROMPT_COMMAND="__last_exit=\$?; [[ \$__last_exit == 0 ]] && __last_exit=; ${PROMPT_COMMAND}"

[[ ! ${BLE_VERSION-} ]] || ble-attach
