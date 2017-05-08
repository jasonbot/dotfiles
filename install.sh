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
}

if [ $OS == "Linux" ]
then
    folder="linux"
elif [ $OS == "Darwin" ]
then
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