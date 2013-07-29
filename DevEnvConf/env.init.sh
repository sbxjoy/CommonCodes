#!/bin/sh
LANGUAGE='utf-8'
this_file=`pwd`"/"$0
project_home=`dirname $this_file`
home=`echo ~`
. $project_home/utils.sh

dirs="$home/backup $home/backup/vim $home/bin"
for dir in $dirs
do
    if [ -a $dir ]
    then
        cecho "$dir already exist!" $yellow
    else
        mkdir $dir
    fi
done

if ([ -L $home/.vim ]) || ([ -e $home/.vim ])
then
    confirm " ~/.vim already exist! replace?"
    if [ $? == '1' ]
    then
        ln -sfn $project_home/vim $home/.vim
    else
        cecho "do not create ~/.vim" $red
    fi
fi

if ([ -L $home/.vimrc ]) || ([ -e $home/.vimrc ])
then
    confirm " ~/.vimrc already exist! replace?"
    if [ $? == '1' ]
    then
        ln -sfn $project_home/vim/_vimrc $home/.vimrc
    else
        cecho "do not create ~/.vimrc" $red
    fi
fi
