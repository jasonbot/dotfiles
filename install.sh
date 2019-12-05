#! /bin/bash

echo HERE WE GO
cd ~
if [ ! -d dotfiles ]
then
    git clone git@github.com:jasonbot/dotfiles.git
fi

cd dotfiles
git pull

OS=`uname`

function install_homebrew {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    for package in $(cat osx_homebrew_packages.txt)
    do
        brew install $package
    done

    pip3 install --user powerline-status
}

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
