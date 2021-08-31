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
export NVIM_HOME="${XDG_DATA_HOME}/nvim"
mkdir -p ~/Programming/work
mkdir -p ~/Programming/personal
mkdir -p "$XDG_CACHE_HOME"/zsh
cd "$HOME"

# -- APT -----------------------------------------------------------------------

sudo apt-get -y update
sudo apt-get -y install build-essential
sudo apt-get -y install \
	python3-pip \
	git \
	zsh

trap 'sudo apt-get -y autoremove' EXIT

# -- DOCKER --------------------------------------------------------------------

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y install \
	docker-ce \
	docker-ce-cli \
	containerd.io
sudo groupadd docker
sudo usermod -aG docker ubuntu

# -- GIT -----------------------------------------------------------------------

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/kazhala/scripts.git ~/Programming/scripts
git clone https://github.com/kazhala/dotbare.git ~/.dotbare
git clone https://github.com/wbthomason/packer.nvim "${NVIM_HOME}/site/pack/packer/start/packer.nvim"
git clone https://github.com/sumneko/lua-language-server "${NVIM_HOME}/lua-language-server"

# -- DOTBARE -------------------------------------------------------------------

source ~/.dotbare/dotbare.plugin.bash
dotbare finit -u https://github.com/kazhala/dotfiles.git
trap 'rm -rf ~/.dotbare' EXIT

# -- HOMEBREW ------------------------------------------------------------------

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
while read -r line; do
	brew install "${line}"
done <"${XDG_CONFIG_HOME}/brew/ubuntu"

# -- lua -----------------------------------------------------------------------

cd "${NVIM_HOME}/lua-language-server"
git submodule update --init --recursive
cd 3rd/luamake
./compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild
cd "$HOME"

# -- rust ----------------------------------------------------------------------

cargo install stylua

# -- NODE ----------------------------------------------------------------------

npm install -g yarn

yarn global add prettier
yarn global add pyright
yarn global add yaml-language-server
yarn global add nodemon
yarn global add bash-language-server

# -- PYTHON --------------------------------------------------------------------

pip3 install -r "$HOME"/.config/pip/requirements.txt
while read -r line; do
	pipx install "${line}"
done <"$XDG_CONFIG_HOME/pip/pipx-requirements.txt"

if pipx list | grep ranger-fm; then
	pipx inject ranger-fm pynvim
fi

# -- SAM -----------------------------------------------------------------------

wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install
trap 'rm aws-sam-cli-linux-x86_64.zip' EXIT
trap 'rm -rf sam-installation' EXIT
