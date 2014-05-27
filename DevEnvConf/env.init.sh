#!/bin/sh
#脚本初始化
LANGUAGE='utf-8'
this_file=`pwd`"/"$0
project_home=`dirname $this_file`
echo $project_home
. $project_home/utils.sh

#创建一些目录
#backup, backup/vim vim的backup目录
#bin 当前用户的bin目录，放一些需要用的工具
dirs="$HOME/backup $HOME/backup/vim"
for dir in $dirs
do
    if test -d $dir
    then
        cecho "$dir 已存在！" $green
    else
        mkdir $dir
    fi
done
git clone https://github.com/gmarik/vundle.git $project_home/vim/bundle/vundle

#vim 相关的link
#vim 目录
link_path $project_home/vim $HOME/.vim
#vimrc
link_path $project_home/vim/vimrc $HOME/.vimrc

#bin 目录的创建和检查
link_path $project_home/bin $HOME/bin
if [[ $PATH != *$HOME/bin* ]]
then
    cecho '$PATH 中不包含 '"$HOME/bin 请手动添加" $red
fi
#添加bash环境参数
# TODO

crontab -l > /tmp/curr.cron
cnt=`cat /tmp/curr.cron | grep $project_home | wc -l`
if test $cnt -eq 0
then
    cecho "crontab 更新脚本不存在！" $yellow
    str="0 * * * * cd $project_home; git pull >> /dev/null 2>&1"
    echo "$str" >> /tmp/curr.cron
    crontab /tmp/curr.cron
    cecho "crontab 更新脚本已经添加！" $green
else
    confirm " crontab 更新脚本已存在，替换吗？"
    if [ $? == '1' ] 
    then
        cat /tmp/curr.cron | grep -v $project_home > /tmp/dest.cron
        str="0 * * * * cd $project_home; git pull >> /dev/null 2>&1"
        echo "$str" >> /tmp/dest.cron
        crontab /tmp/dest.cron
        rm -f /tmp/dest.cron
    else
        cecho "未处理更新脚本" $yellow
    fi
fi
rm -f /tmp/curr.cron
