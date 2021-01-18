#/bin/bash

# setup
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
mkdir -p ~/Programming/work

# install general
sudo apt -y update
sudo apt -y install build-essential
sudo apt-get -y install git
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get -y install npm
sudo apt-get -y install neovim
sudo apt-get -y install tmux
sudo apt-get -y install python3
sudo apt-get -y install python3-venv
sudo apt-get -y install zsh
sudo apt-get -y install fd-find
sudo apt-get -y install fzf
sudo apt-get -y install vifm
sudo apt-get -y install tree
sudo apt-get -y install ripgrep
sudo apt -y autoremove

# git packages
sh -c "$(curl -fsSL https://raw.githubusercontent.com/kazhala/scripts/master/install/zinit_installer.sh)"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/kazhala/dotbare.git ~/.dotbare
git clone https://github.com/kazhala/scripts.git ~/Programming/scripts
git clone https://github.com/kazhala/AWSCloudFormationStacks ~/Programming/aws/cloudformation
git clone https://github.com/kazhala/AWSLambda.git ~/Programming/aws/lambda

# dotbare
source ~/.dotbare/dotbare.plugin.bash
dotbare finit -u https://github.com/kazhala/dotfiles.git
dotbare checkout ubuntu
rm -rf ~/.dotbare

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > ~/rust_install.sh
chmod +x ~/rust_install.sh
. ~/rust_install.sh --no-modify-path -y
rm ~/rust_install.sh
source $XDG_DATA_HOME/cargo/env
cargo install lsd
cargo install git-delta

# vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -c 'PlugInstall|q|q'
nvim -c 'CocInstall -sync coc-css coc-eslint coc-html coc-json coc-markdownlint coc-pairs coc-prettier coc-pyright coc-snippets coc-tsserver coc-yaml|q|q'
nvim -c 'CocInstall -sync coc-git|q|q'

# python
sudo apt install -y python3-pip
sudo apt-get -y install python-setuptools
pip3 install -r $HOME/.config/pip/requirements.txt
sudo pip3 install awscli
sudo pip3 install fzfaws

# enable password ssh
sudo sed -i "s/^PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service ssh restart
