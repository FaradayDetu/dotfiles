#!/bin/bash

setup_colors() {
  # Only use colors if connected to a terminal
  if [ -t 1 ]; then
    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    CYAN=$(printf '\033[36m')
    BLUE=$(printf '\033[34m')
    LBLUE=$(printf '\033[94m')
    BOLD=$(printf '\033[1m')
    RESET=$(printf '\033[m')
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    RESET=""
  fi
}
setup_colors


# install oh-my-zsh
echo "${BLUE}installing oh-my-zsh${RESET}"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "${BLUE}installing plugins${RESET}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "${CYAN}installing power10k theme${RESET}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
echo "${CYAN}installing spaceship theme${RESET}"
git clone https://github.com/denysdovhan/spaceship-prompt.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt --depth=1
ln -s ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme

# variables
dir=$HOME/dotfiles
olddir=$HOME/dotfiles_old
files="vimrc zshrc p10k.zsh"

# create backup folder
mkdir -p $olddir
# move to dotfiles folder
cd $dir

echo "${BLUE}updating dotfiles${RESET}"
for file in $files; do
  echo "${LBLUE}backing $file up ($olddir)${RESET}"
  mv ~/.$file $olddir
  echo "${CYAN}creating symlink to $file${RESET}"
  ln -s $dir/$file ~/.$file
done
echo "${GREEN}We are done! 🥳${RESET}"

# change to zsh
echo "${YELLOW}changing shell...${RESET}"
zsh=$(command -v zsh)
if ! chsh -s "$zsh"; then
  fmt_error "chsh command unsuccessful. Change your default shell manually."
else
  export SHELL="$zsh"
  echo "${GREEN}Shell successfully changed to '$zsh'.${RESET}"
fi

# install powerline fonts
cd /tmp && git clone https://github.com/powerline/fonts.git && cd fonts && ./install.sh

exec zsh -l
