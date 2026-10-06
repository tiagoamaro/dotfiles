ZSH=$HOME/.oh-my-zsh
ZSH_THEME="bira"
COMPLETION_WAITING_DOTS="true"
plugins=(zsh-autosuggestions zsh-syntax-highlighting)

# Keeps pasted URLs fast and unescaped with zsh-autosuggestions active.
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

source $ZSH/oh-my-zsh.sh

HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE

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
alias claudet='command claude --model opus --effort medium --name thinker --settings "{\"theme\":\"custom:model-opus\"}"'
alias claudee='command claude --model sonnet --effort medium --name engineer --settings "{\"theme\":\"custom:model-sonnet\"}"'
alias claudep='command claude --model haiku --name printer --settings "{\"theme\":\"custom:model-haiku\"}"'
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
# Usage: nosleep [minutes], default 60. One root process so the re-enable doesn't need sudo after its cache expires.
nosleep() {
  local minutes="${1:-60}"
  [[ "$minutes" =~ ^[0-9]+$ ]] || { echo "usage: nosleep [minutes]" >&2; return 1; }
  sudo -v || return 1
  sudo nohup sh -c "pmset -a disablesleep 1; sleep $((minutes * 60)); pmset -a disablesleep 0" >/dev/null 2>&1 &!
  echo "Sleep disabled for $minutes min"
}
alias shrug="echo \"\\\`¯\_(ツ)_/¯\\\`\" | pbcopy"

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR="code --wait"

export PATH="$HOME/.asdf/shims:$HOME/.asdf:$PATH"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH:$HOME/.lmstudio/bin"

eval "$(direnv hook zsh)"
