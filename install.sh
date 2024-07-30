#! /bin/bash

OS=`uname`
DOTFILE_DIRECTORY=~/.dotfiles

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
    git config --global --replace-all user.email "jason.scheirer@gmail.com"
    echo REMEMBER TO git config --global --replace-all user.email "work@email.com"
}

function install_homebrew {
    echo "------ HOMEBREW -------"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    for package in $(cat osx_homebrew_packages.txt)
    do
        brew install $package
    done
}

function install_oh_my {
    echo "------ OH MY -------"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    echo "(Setting theme)"
    sed -I "" "s/^ZSH_THEME=.*/DEFAULT_USER=$USER\nZSH_THEME=agnoster/" ~/.zshrc
}

configure_git
install_oh_my

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
    echo $item -> $new_item
    if [ -d $item ]
    then
        cp -r $item ~/$new_item
    else
        cp $item ~/$new_item
    fi
done
