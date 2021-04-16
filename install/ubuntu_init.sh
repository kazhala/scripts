#/bin/bash

# setup
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export OS_DISTRO="UBUNTU"
mkdir -p ~/Programming/work
mkdir -p ~/Programming/personal
mkdir -P "$XDG_CACHE_HOME"/zsh

# system packages
sudo apt -y update
sudo apt -y install build-essential
sudo apt -y install git
sudo apt -y install pkg-config
sudo apt -y install libssl-dev
sudo apt -y install libevent-dev
sudo apt -y install ncurses-dev 
sudo apt -y install bison
sudo apt -y install apt-transport-https 
sudo apt -y install ca-certificates
sudo apt -y install gnupg-agent
sudo apt -y install software-properties-common

# dev packages
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt -y install nodejs
sudo apt -y install npm
sudo apt -y install neovim
sudo apt -y install python3
sudo apt -y install python3-venv
sudo apt -y install zsh
sudo apt -y install fd-find
sudo apt -y install fzf
sudo apt -y install vifm
sudo apt -y install tree
sudo apt -y install ripgrep
sudo apt -y install shellcheck
sudo apt -y install httpie
sudo apt -y install pipx

# tmux
wget https://github.com/tmux/tmux/releases/download/3.2/tmux-3.2.tar.gz
tar -zxf tmux-*.tar.gz
cd tmux-*/
./configure
make && sudo make install

# terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt -y install terraform
sudo apt -y install terraform-ls

# git packages
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/kazhala/scripts.git ~/Programming/scripts
git clone https://github.com/kazhala/AWSCloudFormationStacks ~/Programming/personal/cloudformation

# dotbare
git clone https://github.com/kazhala/dotbare.git
source dotbare/dotbare.plugin.bash
dotbare finit -u https://github.com/kazhala/dotfiles.git

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rust_install.sh
chmod +x rust_install.sh
. rust_install.sh --no-modify-path -y
source $XDG_DATA_HOME/cargo/env
cargo install lsd
cargo install git-delta
cargo install tealdeer

# vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -c 'PlugInstall|q|q'

# python
sudo apt -y install python3-pip
sudo apt -y install python-setuptools
pip3 install -r $HOME/.config/pip/requirements.txt
while read line; do
    pipx install "${line}"
done < $HOME/.config/pip/pipx-requirements.txt

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt -y install docker-ce
sudo apt -y install docker-ce-cli
sudo apt -y install containerd.io
sudo groupadd docker
sudo usermod -aG docker ubuntu

# aws sam
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install

# enable password ssh
sudo sed -i "s/^PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service ssh restart

# cleanup
rm tmux-3.2.tar.gz
rm -rf tmux-3.2
rm aws-sam-cli-linux-x86_64.zip
rm -rf sam-installation
rm ~/rust_install.sh
rm -rf dotbare
sudo apt -y autoremove
