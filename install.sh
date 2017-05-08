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

if [ $OS == "Linux" ]
then
    folder="linux"
elif [ $OS == "Darwin" ]
then
    folder="osx"
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
