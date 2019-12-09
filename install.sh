#! /bin/bash

echo HERE WE GO
cd ~
if [ ! -d dotfiles ]
then
    if ! git clone git@github.com:jasonbot/dotfiles.git
    then
        echo "SSH/GitHub is not set up; using HTTPS (CRAP)"
        git clone https://github.com/jasonbot/dotfiles.git
    fi
fi

cd dotfiles
git pull

OS=`uname`

function configure_git() {
    git config --global --replace-all core.pager "less -F -X"
    git config --global --replace-all user.name "Jason Scheirer"
    if which vim
    then
        git config --global core.editor vim
    else
        echo "NO VIM?"
    fi
    git config --global --replace-all user.email "jason.scheirer@gmail.com"
    echo REMEMBER TO git config --global --replace-all user.email "work@email.com"
}

function install_homebrew {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    for package in $(cat osx_homebrew_packages.txt)
    do
        brew install $package
    done

    pip3 install --user powerline-status
}

configure_git

if [ $OS == "Linux" ]
then
    folder="linux"
elif [ $OS == "Darwin" ]
then
    # The only good minimize effect
    defaults write com.apple.dock mineffect -string suck
    killall Dock

    folder="osx"

    install_homebrew
else
    echo "THIS OS IS BAD AND YOU SHOULD FEEL BAD"
    exit 1
fi

cd $folder

for item in $(ls)
do
    new_item=$(echo $item | sed s/^_/./)
    if [ -d $item ]
    then
        cp -r $item ~/$new_item
    else
        cp $item ~/$new_item
    fi
done
