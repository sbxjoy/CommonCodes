#!/bin/sh
#脚本初始化
LANGUAGE='utf-8'
this_file=`pwd`"/"$0
project_home=`dirname $this_file`
echo $project_home
. $project_home/utils.sh

cecho '--------------------------------------------------------------------'
cecho '----------------------Linux 使用环境初始化开始----------------------'
cecho '--------------------------------------------------------------------'

os=$(lsb_release -a | grep Distributor | awk -F ':' '{print $2}' | sed 's/\t//g')
if [ 'CentOS' != $os ] && [ 'Ubuntu' != $os ]
then
    cecho 'unknown operate system!' $red
    exit;
fi
cecho "\ncurrent operate system is $os \n" $green

if [ ! -e $HOME/.bash_profile ] && [ -e $HOME/.profile ]
then
    cecho "$HOME/.bash_profile 文件不存在" $yellow
    cp $HOME/.profile $HOME/.bash_profile
    if [ $? == 0 ]
    then
        printf "%-80s\t" "$HOME/.bash_profile 文件创建成功"
        cecho "[OK]" $green
    else
        printf "%-80s\t" "$HOME/.bash_profile 文件创建失败"
        cecho "[ERROR]" $red
        exit;
    fi
fi

#创建一些目录
#backup, backup/vim vim的backup目录
cecho "\n创建一些需要的目录"
dirs="$HOME/backup $HOME/backup/vim $HOME/backup/vim/_undodir"
for dir in $dirs
do
    if test -d $dir
    then
        printf "%-80s\t" "$dir 已存在！"
        cecho '[OK]' $yellow
    else
        mkdir $dir
        printf "%-80s\t" "$dir"
        cecho '[OK]' $green
    fi
done
cecho "目录创建完成\n"

cecho "\n开始配置vim"
#vim 目录
link_path $project_home/vim $HOME/.vim
flag=$?
if [ $flag -eq 0 ] || [ $flag -eq 1 ]
then
    printf "%-80s\t" ".vim 目录链接完成"
    cecho "[OK]" $green
else
    printf "%-80s\t" ".vim 目录未替换"
    cecho "[OK]" $yellow
fi
#vimrc
link_path $project_home/vim/vimrc $HOME/.vimrc
flag=$?
if [ $flag -eq 0 ] || [ $flag -eq 1 ]
then
    printf "%-80s\t" ".vimrc 文件链接完成"
    cecho "[OK]" $green
else
    printf "%-80s\t" ".vimrc 文件未替换"
    cecho "[OK]" $yellow
fi

vundle_path=$project_home/vim/bundle/vundle
if [ ! -d $vundle_path ]
then
    cecho 'git clone vundle'
    git clone --progress https://github.com/gmarik/vundle.git $project_home/vim/bundle/vundle
    if [ $? -eq 0 ]
    then
        printf "%-80s\t" "git clone vundle 成功"
        cecho "[OK]" $green
    else
        printf "%-80s\t" "git clone vundle 失败"
        cecho "[ERROR]" $yellow
    fi
else
    printf "%-80s\t" "vundle 所在的目录已存在！"
    cecho "[OK]" $yellow
fi

# 下载phpctags
if [ ! -f ~/bin/phpctags ] || [ $(ls -l ~/bin/phpctags | awk '{ print $5 }') -lt '2000000' ]
then
    cecho '下载 phpctags'
    curl -S http://vim-php.com/phpctags/install/phpctags.phar > ~/bin/phpctags
    chmod +x ~/bin/phpctags
    printf "%-80s\t" 'phpctags 下载完成！'
    cecho '[OK]' $green
else
    printf "%-80s\t" "phpctags 已存在！"
    cecho '[OK]' $yellow
fi
cecho "vim配置完成\n"

cecho "\n开始配置shell"
#bin 目录的创建和检查
profile_path=$HOME/.bash_profile

link_path $project_home/bin $HOME/bin
flag=$?
if [ $flag -eq 0 ] || [ $flag -eq 1 ]
then
    printf "%-80s\t" "$HOME/bin 目录链接完成"
    cecho "[OK]" $green
else
    printf "%-80s\t" "$HOME/bin 目录未替换"
    cecho "[OK]" $yellow
fi

own_profile_path=$project_home/bash_profile
cnt=$(cat $profile_path | grep $own_profile_path | wc -l)
if [ $cnt -eq 0 ]
then
    echo -e "\n\n#lx's own bash\n. $own_profile_path\n" >> $profile_path
    printf "%-80s" "$own_profile_path 配置完成"
    cecho "[OK]" $green
else
    printf "%-80s" "$own_profile_path 已配置"
    cecho "[OK]" $yellow
fi

bashmarks_path=$project_home/bashmarks
if [ ! -d $bashmarks_path ]
then
    git clone --progress https://github.com/huyng/bashmarks.git $bashmarks_path
else
    printf "%-80s\t" "bashmarks 目录已存在！"
    cecho "[OK]" $yellow
    pushd $bashmarks_path
    git pull
    if [ $? == 0 ]
    then
        printf "%-80s\t" "bashmarks 更新完成！"
        cecho "[OK]" $green
    else
        printf "%-80s\t" "bashmarks 更新出错！"
        cecho "[WARNING]" $yellow
    fi
    popd
fi
cnt=$(cat $profile_path | grep $bashmarks_path | wc -l)
if [ $cnt -eq 0 ]
then
    echo -e "\n. $bashmarks_path/bashmarks.sh\n" >> $profile_path
    printf "%-80s" "$bashmarks_path 配置完成"
    cecho "[OK]" $green
else
    printf "%-80s" "$bashmarks_path 已配置"
    cecho "[OK]" $yellow
fi


cecho "shell配置完成\n"

# cron脚本安装
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
