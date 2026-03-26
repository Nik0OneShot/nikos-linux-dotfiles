autoload -U colors && colors	# automatically load colours
PS1="%B%{$fg[blue]%}[%{$fg[blue]%}%n%{$fg[blue]%}@%{$fg[blue]%}%M %{$fg[blue]%}%~%{$fg[blue]%}]%{$reset_color%}$%b " # changes prompt
setopt autocd       # automatically cd into typed directory.
stty stop undef     # disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history" # make sure to do mkdir -p ~/.cache/zsh/history
setopt inc_append_history

# basic auto/tab complete:

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)       # include hidden files.

# plugins

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh # adds syntax highlighting.
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh # adds autosuggestions.

fastfetch # automatically boot fastfetch upon opening zsh (do chsh /usr/bin/zsh to make it happen on terminal startup)

# aliases, for games / programs / whatever / niggers / rape / chicken tendies / africa
# software
# quick yt-dlp command

alias ytdlp='yt-dlp -f "bestvideo+bestaudio" --write-description --write-thumbnail -o "~/youtube_downloads/%(uploader)s/%(title)s/%(title)s.%(ext)s"'

# quick snapper snapshot

snapper_snapshot() {
  if [ -z "$1" ]; then
    echo "Usage: snapper_snapshot NAME" >&2
    return 1
  fi
  sudo snapper -c root create -d "$1"
}
alias snapshot='snapper_snapshot'

# quick update

update_system() {
  set -e
  echo "Updating system packages..."
  sudo pacman -Syu --noconfirm

  if command -v yay >/dev/null 2>&1; then
    echo "Updating AUR packages..."
    yay -Syu --noconfirm
  fi

  echo "Removing orphaned packages..."
  sudo pacman -Rns --noconfirm $(pacman -Qtdq 2>/dev/null || true)

  echo "Cleaning pacman cache (keep last 3 versions)..."
  sudo paccache -r -k3

  echo "Removing unused cached AUR packages (yay)..."
  if command -v yay >/dev/null 2>&1; then
    yay -Sc --noconfirm
  fi

  echo "Done."
}
alias update='update_system'

# games
#
# roblox

alias roblox="flatpak run org.vinegarhq.Sober"
