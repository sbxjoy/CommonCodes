#!/bin/sh
if [ `dirname $0` != '.' ]
then
	echo "please cd the dir of init.sh"
	exit;
fi

mkdir ~/backup
mkdir ~/backup/vim
ln -s `pwd` ~/.vim
ln -s ~/.vim/_vimrc ~/.vimrc
