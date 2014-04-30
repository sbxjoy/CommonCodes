#!	/usr/local/bin/bash

#	print colored text
#	$1 = message
#	$2 = color

#	格式化输出
export black='\E[0m\c'
export boldblack='\E[1;0m\c'
export red='\E[31m\c'
export boldred='\E[1;31m\c'
export green='\E[32m\c'
export boldgreen='\E[1;32m\c'
export yellow='\E[33m\c'
export boldyellow='\E[1;33m\c'
export blue='\E[34m\c'
export boldblue='\E[1;34m\c'
export magenta='\E[35m\c'
export boldmagenta='\E[1;35m\c'
export cyan='\E[36m\c'
export boldcyan='\E[1;36m\c'
export white='\E[37m\c'
export boldwhite='\E[1;37m\c'
export EXPORT_LANGUAGE="echo -n"

c_notify=$boldcyan
c_error=$boldred


cecho()
{
    if [ $LANGUAGE = "utf-8" ] 
    then
        message=$1
    else
        echo $1 > /tmp/deploy_tools_tmp
        message=`iconv -f "utf-8" -t $LANGUAGE /tmp/deploy_tools_tmp`
    fi
	color=${2:-$black}

	echo -e "$color"
	echo -e "$message"
	tput sgr0			# Reset to normal.
	echo -e "$black"
	return
}

decho()
{
    if [ $LANGUAGE = "utf-8" ] 
    then
        message=$1
    else
        echo $1 > /tmp/deploy_tools_tmp
        message=`iconv -f "utf-8" -t $LANGUAGE /tmp/deploy_tools_tmp`
    fi
	if [ $UTILS_DEBUG -eq 1 ] 
	then
		color=${2:-$black}

		echo -e "$color"
		echo -e "$message"
		tput sgr0			# Reset to normal.
		echo -e "$black"
	fi
}

cread()
{
	color=${4:-$black}

	echo -e "$color"
	read $1 "$2" $3 
	tput sgr0			# Reset to normal.
	echo -e "$black"
	return
}

#	确认用户的输入
confirm()
{
    if [ $LANGUAGE = "utf-8" ] 
    then
        message=$1
    else
        echo $1 > /tmp/deploy_tools_tmp
        message=`iconv -f "utf-8" -t $LANGUAGE /tmp/deploy_tools_tmp`
    fi
	while [ 1 = 1 ]
	do
		cread -p "$message [y/n]: " CONTINUE $c_notify
		if [ "y" = "$CONTINUE" ]; then
		  return 1;
		fi

		if [ "n" = "$CONTINUE" ]; then
		  return 0;
		fi
	done

	return 0;
}

error_confirm()
{
    if [ $LANGUAGE = "utf-8" ]
    then
        message=$1
    else
        echo $1 > /tmp/deploy_tools_tmp
        message=`iconv -f "utf-8" -t $LANGUAGE /tmp/deploy_tools_tmp`
    fi
	while [ 1 = 1 ]
	do
		cread -p "$message [y/n]: " CONTINUE $c_error
		if [ "y" = "$CONTINUE" ]; then
		  return 1;
		fi

		if [ "n" = "$CONTINUE" ]; then
		  return 0;
		fi
	done

	return 0;
}

#  获取当前的时间
now()
{
	date +%Y%m%d%H%M%S;
}

########################################
# 检查参数数量是否正确
# check_args_num function_name expect_num achieved_num
########################################
check_args_num()
{
	if [ $# -ne 3 ] 
	then
		echo "function check_args_num  expect 3 args, but achieved $? args.";
		exit 1;
	fi
	local func_name=$1;
	local expect_num=$2;
	local achieve_num=$3;
	if [ $expect_num -ne $achieve_num ]
	then
		echo "function $func_name expect $expect_num args, but achieved $achieve_num args.";
		exit 1;
	fi
}

########################################
# 创建link
# link_path sorce_path dest_path
########################################
link_path()
{
    source_path=$1
    dest_path=$2
    if ([ -L $dest_path ]) || ([ -e $dest_path ])
    then
        confirm " $dest_path 已经存在，替换吗？"
        if [ $? == '1' ]
        then
            rm -fr $dest_path
            ln -sfn $source_path $dest_path
        else
            cecho "未处理 $dest_path" $yellow
        fi
    else
        ln -sfn $source_path $dest_path
    fi
}

########################################
# 如果文件中不存在该行内容，则追加
# filename content
########################################
add_to_file()
{
    filename=$1
    content=$2
    egrep -e "^$content$" $filename
    echo $?
}
add_to_file utils.sh "add_to_file()" 