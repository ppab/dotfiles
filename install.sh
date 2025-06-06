

#!/bin/bash

set -e

echo "Bootstrapping your environment..."

# Link dotfiles (or copy, depending on strategy)
#ln -sf "$PWD/zshrc" ~/.zshrc
#ln -sf "$PWD/gitconfig" ~/.gitconfig

# Make scripts executable
chmod +x bin/*

# Ensure ~/bin is in your PATH
mkdir -p ~/.local/bin
cp bin/* ~/.local/bin/
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

echo "Done. Reload your shell or run: source ~/.zshrc"

