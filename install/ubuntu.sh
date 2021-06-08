#!/bin/bash
# shellcheck disable=SC2164
# shellcheck disable=SC1090

# -- INIT ----------------------------------------------------------------------

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export OS_DISTRO="UBUNTU"
export NONINTERACTIVE=1
mkdir -p ~/Programming/work
mkdir -p ~/Programming/personal
mkdir -p "$XDG_CACHE_HOME"/zsh
cd "$HOME"

# -- APT -----------------------------------------------------------------------

sudo apt-get -y update
sudo apt-get -y install \
	git \
	zsh

# -- DOCKER -----------------------------------------------------------------------

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y install \
	docker-ce \
	docker-ce-cli \
	containerd.io
sudo groupadd docker
sudo usermod -aG docker ubuntu

# -- GIT --------------------------------------------------------------------------

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/kazhala/scripts.git ~/Programming/scripts
git clone https://github.com/kazhala/dotbare.git ~/.dotbare

# -- DOTBARE ----------------------------------------------------------------------

source ~/.dotbare/dotbare.plugin.bash
dotbare finit -u https://github.com/kazhala/dotfiles.git
rm -rf ~/.dotbare

# -- HOMEBREW ---------------------------------------------------------------------

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install python3
brew install tmux
brew install shfmt
brew install terraform
brew install terraform-ls
brew install terraform-docs
brew install rust
brew install lsd
brew install git-delta
brew install tealdeer
brew install neovim
brew install fzf
brew install vifm
brew install tree
brew install ripgrep
brew install shellcheck
brew install httpie
brew install fd
brew install pipx
brew install node
brew instlal packer
brew install lua
brew install luarocks

# -- VIM --------------------------------------------------------------------------

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -c 'PlugInstall|q|q'

# -- NODE -------------------------------------------------------------------------

npm install -g pyright
npm install -g nodemon

# -- PYTHON -----------------------------------------------------------------------

pip3 install -r "$HOME"/.config/pip/requirements.txt
while read -r line; do
	pipx install "${line}"
done <"$HOME"/.config/pip/pipx-requirements.txt

# -- SAM --------------------------------------------------------------------------

wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install
rm aws-sam-cli-linux-x86_64.zip
rm -rf sam-installation

# -- FINAL ------------------------------------------------------------------------

sudo apt-get -y autoremove
