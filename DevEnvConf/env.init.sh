#!/bin/sh
git clone https://github.com/sbxjoy/CommonCodes.git

#脚本初始化
LANGUAGE='utf-8'
this_file=`pwd`"/"$0
project_home=`dirname $this_file`
echo $project_home
echo $0
echo $1
. $project_home/utils.sh

#创建一些目录
#backup, backup/vim vim的backup目录
#bin 当前用户的bin目录，放一些需要用的工具
dirs="$HOME/backup $HOME/backup/vim"
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
link_path $project_home/vim $HOME/.vim
#vimrc
link_path $project_home/vim/_vimrc $HOME/.vimrc

#bin 目录的创建和检查
link_path $project_home/bin $HOME/bin
if [[ $PATH != *$HOME/bin* ]]
then
    cecho '$PATH 中不包含 '"$HOME/bin 请手动添加" $red
fi

#添加bash环境参数
