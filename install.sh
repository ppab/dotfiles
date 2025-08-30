

#!/bin/bash

set -e

# Parse command line arguments
UPDATE_MODE=false
while [[ $# -gt 0 ]]; do
  case $1 in
    --update)
      UPDATE_MODE=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

echo "Bootstrapping your environment..."

# Link dotfiles (or copy, depending on strategy)
#ln -sf "$PWD/zshrc" ~/.zshrc
#ln -sf "$PWD/gitconfig" ~/.gitconfig

# Make scripts executable
chmod +x bin/*

# Ensure ~/bin is in your PATH
mkdir -p ~/.local/bin
cp bin/* ~/.local/bin/

# Only add PATH export if not in update mode or if it doesn't already exist
if [[ "$UPDATE_MODE" == "false" ]]; then
  if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.zshrc 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
  fi
fi

echo "Done. Reload your shell or run: source ~/.zshrc"

