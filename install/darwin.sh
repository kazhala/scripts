#!/bin/bash
# shellcheck disable=SC2164
# shellcheck disable=SC1090
# shellcheck disable=SC2002

function cleanup() {
	sudo apt-get -y autoremove
	[[ -d "$HOME/.dotbare" ]] && rm -rf ~/.dotbare
}

trap cleanup EXIT

# -- INIT ----------------------------------------------------------------------

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export OS_DISTRO="MACOS"
export NONINTERACTIVE=1
export NVIM_HOME="${XDG_DATA_HOME}/nvim"
mkdir -p ~/Programming
mkdir -p "$XDG_CACHE_HOME"/zsh
cd "$HOME"

# -- HOMEBREW ------------------------------------------------------------------

cat "${XDG_CONFIG_HOME}/brew/darwin" | xargs brew install
brew tap homebrew/cask-fonts
cat "${XDG_CONFIG_HOME}/brew/casks" | xargs brew install --cask

# -- GIT -----------------------------------------------------------------------

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/kazhala/scripts.git ~/Programming/scripts
git clone https://github.com/kazhala/dotbare.git ~/.dotbare
git clone https://github.com/wbthomason/packer.nvim "${NVIM_HOME}/site/pack/packer/start/packer.nvim"
git clone https://github.com/sumneko/lua-language-server "${NVIM_HOME}/lua-language-server"

# -- DOTBARE -------------------------------------------------------------------

source ~/.dotbare/dotbare.plugin.bash
dotbare finit -u https://github.com/kazhala/dotfiles.git

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

while read -r line; do
	yarn global add "${line}"
done <"${XDG_CONFIG_HOME}/yarn/packages"

# -- PYTHON --------------------------------------------------------------------

pip3 install -r "$HOME"/.config/pip/requirements.txt
while read -r line; do
	pipx install "${line}"
done <"$XDG_CONFIG_HOME/pip/pipx-requirements.txt"

if pipx list | grep ranger-fm; then
	pipx inject ranger-fm pynvim
fi
