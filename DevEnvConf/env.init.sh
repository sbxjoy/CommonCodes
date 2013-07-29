#!/bin/sh

#脚本初始化
LANGUAGE='utf-8'
this_file=`pwd`"/"$0
project_home=`dirname $this_file`
home=`echo ~`
. $project_home/utils.sh

#创建一些目录
#backup, backup/vim vim的backup目录
#bin 当前用户的bin目录，放一些需要用的工具
dirs="$home/backup $home/backup/vim"
for dir in $dirs
do
    if [ -a $dir ]
    then
        cecho "$dir 已存在！" $green
    else
        mkdir $dir
    fi
done

#vim 相关的link
#vim 目录
link_path $project_home/vim $home/.vim
#vimrc
link_path $project_home/vim/_vimrc $home/.vimrc

#bin 目录的创建和检查
link_path $project_home/bin $home/bin
if [[ $PATH != *$home* ]]
then
    cecho '$PATH 中不包含 '"$home/bin 请手动添加" $red
fi
