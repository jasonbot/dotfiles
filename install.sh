#! /bin/bash

OS=`uname`
DOTFILE_DIRECTORY=~/.dotfiles

function generate_ssh_key {
    if [ ! -f ~/.ssh/id_ed25519 ]
    then
        echo "Attempting to create an SSH key"
        ssh-keygen -t ed25519
    fi
}

function configure_git {
    echo "------ GIT -------"
    git config --global --replace-all core.pager "less -F -X"
    git config --global --replace-all user.name "Jason Scheirer"
    if which vim
    then
        git config --global core.editor vim
    else
        echo "NO VIM?"
    fi
    if [ -f ~/.ssh/id_ed25519.pub ]
    then
        git config --global gpg.format ssh
        git config --global user.signingkey ~/.ssh/id_ed25519.pub
        git config --global commit.gpgsign true
    fi
    if which delta
    then
        git config --global core.pager delta
        git config --global interactive.diffFilter "delta --color-only"
        git config --global delta.navigate true
        git config --global delta.light false
        git config --global merge.conflictstyle diff3
    fi
    git config --global --replace-all user.email "jason.scheirer@gmail.com"
    echo REMEMBER TO git config --global --replace-all user.email "work@email.com"
}

function install_homebrew {
    echo "------ HOMEBREW -------"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    for package in $(cat macos_homebrew_packages.txt)
    do
        brew install $package
    done
}

generate_ssh_key
configure_git

echo "------ COPYING DOTFILES -------"
cd ~
if [ ! -d $DOTFILE_DIRECTORY ]
then
    if ! git clone git@github.com:jasonbot/dotfiles.git $DOTFILE_DIRECTORY
    then
        echo "SSH/GitHub is not set up; using HTTPS (CRAP)"
        git clone https://github.com/jasonbot/dotfiles.git $DOTFILE_DIRECTORY
    fi
fi

cd $DOTFILE_DIRECTORY
git pull

if [ $OS == "Linux" ]
then
    folder="linux"
    # For ChimeraOS
    gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
    
    # Install fonts to well known location
    mkdir -p ~/.local/share/fonts
    cp -r ./fonts/  ~/.local/share/fonts
elif [ $OS == "Darwin" ]
then
    folder="macos"

    # The only good minimize effect
    defaults write com.apple.dock mineffect -string suck
    killall Dock

    # Open fonts in Font Book for user to install
    open ./fonts/*

    install_homebrew
else
    echo "THIS OS IS BAD AND YOU SHOULD FEEL BAD"
    exit 1
fi

cd $folder

for item in $(ls)
do
    new_item=$(echo $item | sed s/^_/./)
    echo $item -> $new_item
    if [ -d $item ]
    then
        cp -r $item ~/$new_item
    else
        cp $item ~/$new_item
    fi
done
