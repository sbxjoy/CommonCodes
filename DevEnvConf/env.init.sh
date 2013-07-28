#!/bin/sh
function file_exist_replace()
{
    echo "$1 already exist! replace?[y/n]"
    return
}

if [ `dirname $0` != '.' ]
then
	echo "please cd the dir of init.sh"
	exit;
fi

this_file=`pwd`"/"$0
project_home=`dirname $this_file`
home=`echo ~`

dirs="$home/backup $home/backup/vim"
for dir in $dirs
do
    if [ -a $dir ]
    then
        file_exist_replace $dir
    else
        mkdir $dir
    fi
done

#if [ -a ~/.vim ]
#then
#    echo "~/.vim already exist!"
#else
#    ln -s `pwd` ~/.vim
#fi

#if [ -a ~/.vimrc ]
#then
#    echo ""

#ln -s ~/.vim/_vimrc ~/.vimrc
