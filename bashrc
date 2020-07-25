. $HOME/.asdf/asdf.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  export HOMEBREW_PREFIX="/usr/local"
else
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
fi
export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:$PATH"
export PATH=$HOME/.cargo/bin:$HOME/bin:$PATH
