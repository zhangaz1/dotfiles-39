#!/bin/bash

set -e # Immediately rethrows exceptions
set -x # Logs every command on Terminal

function toClipboard {
 if command -v pbcopy > /dev/null; then
   pbcopy
 elif command -v xclip > /dev/null; then
   xclip -i -selection c
 else
   echo "No clipboard tool found. Here's what you need to paste into the developer console:"
   cat -
 fi
}

################################################################################
### Install Applications
################################################################################

# Homebrew - https://brew.sh
echo " * Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo " * Homebrew installed successfully!"

# rbenv - https://github.com/rbenv/rbenv
echo " * Installing rbenv"
brew install rbenv ruby-build
echo " * rbenv installed successfully!"

# Ruby - https://www.ruby-lang.org/en/
echo " * Installing Ruby 2.6.5"
rbenv install 2.6.5
rbenv global 2.6.5
echo " * Ruby 2.6.5 installed successfully!"

# Yarn - https://yarnpkg.com
echo " * Installing Yarn"
brew install yarn
echo " * Yarn installed successfully!"

# hub - https://hub.github.com
echo " * Installing hub"
brew install hub
echo " * hub installed successfully!"

# Heroku - https://devcenter.heroku.com/articles/heroku-cli
echo " * Installing Heroku"
brew tap heroku/brew
brew install heroku
echo " * Heroku installed successfully!"

################################################################################
### Configure SSH key
################################################################################

# Generate new SSH key
echo "Just press enter on this next iteration, and then create a memorable passphrase"
ssh-keygen -t rsa -b 4096 -C "rogerluan.oba@gmail.com"

# Add your SSH key to the ssh-agent
# Start the ssh-agent in the background
eval "$(ssh-agent -s)"
# Automatically load keys into the ssh-agent and store passphrases in the keychain
# Host *
#   AddKeysToAgent yes
#   UseKeychain yes
#   IdentityFile ~/.ssh/id_rsa
printf "Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_rsa\n" >> ~/.ssh/config

# Add your SSH private key to the ssh-agent and store your passphrase in the keychain
ssh-add -K ~/.ssh/id_rsa

# Copy the contents of the id_rsa.pub file to clipboard
cat ~/.ssh/id_rsa.pub | toClipboard
echo "Copied SSH key to clipboard!"
echo "Opening Safari, create a descriptive title to describe this computer and paste the key there"
open -a safari https://github.com/settings/ssh/new