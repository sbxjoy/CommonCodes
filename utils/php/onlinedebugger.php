<?php
/**
 * @file onlinedebugger.php
 * @author lvxiang
 * @date 2014/05/29
 * @version $Revision: 0.1 $
 * @brief 线上输出
 *
 **/

/**
 * @example:
 *
<?php
require_once('onlinedebugger.php');
define('PROCESS_START_TIME', microtime(true) * 1000);
$debug_key = 'debug';
Onlinedebugger::init($debug_key);
$msg = 'debug info';
Onlinedebugger::appendMessage($msg);

打开网页在GET参数中加入$debug_key=$debug_val即可在页面最末尾输出所有的message和对应时间

    **/
class OnlineDebugger {
    private static $flag = false;
    private static $msgs = array();
    private static $start_time = null;

    public static function init($debug_key = 'debug', $debug_val = 'debug')
    {/*{{{*/
        if (!empty($_GET[$debug_key]) && $_GET[$debug_key] == $debug_val) {
            self::$flag = true;
            if (empty($_COOKIE[$debug_key]) || $_COOKIE[$debug_key] != $debug_val) {
                setcookie($debug_key, $debug_val, 0, '/');
            }
        }
        if (!empty($_COOKIE[$debug_key]) && $_COOKIE[$debug_key] == $debug_val) {
            self::$flag = true;
        }
        if (self::$flag == true) {
            register_shutdown_function('OnlineDebugger::printMessage');
            self::$start_time = defined(PROCESS_START_TIME)
                ? PROCESS_START_TIME : microtime(true) * 1000;
            $time = date('Y-m-d H:i:s', self::$start_time / 1000);
            self::appendMessage("script initialize, start time : $time");
        }
    }/*}}}*/

    public static function printMessage()
    {/*{{{*/
        if (true !== self::$flag) {
            return;
        }
        $time = microtime(true) * 1000 - self::$start_time;
        self::appendMessage("script running over, execute spend time : $time ms");
        echo '<table border="1" bordercolor="#a0c6e5" style="border-collapse:collapse;">';
        echo '<tr><th>time spend</th><th>location</th><th>message</th><th>datas</th></tr>';
        foreach (self::$msgs as $msg) {
            $data = array();
            foreach ($msg['data'] as $k => $v) {
                $data[] = "$k : $v";
            }
            $line_ary = array(
                $msg['time'] - self::$start_time.'ms',
                "{$msg['file']} line {$msg['line']}",
                $msg['msg'],
                implode('<br/>', $data),
            );
            echo '<tr><td>'.implode('</td><td>', $line_ary).'</td></tr>';
        }
        echo '</table>';
    }/*}}}*/

    public static function appendMessage($msg, $type = '', $data = array() )
    {/*{{{*/
        if (true !== self::$flag) {
            return;
        }
        $trace = debug_backtrace();
        $depth = count($trace) - 1 ;
        $file = empty($trace[$depth]['file']) ? '' : basename($trace[$depth]['file']);
        $line = empty($trace[$depth]['line']) ? '' : basename($trace[$depth]['line']);
        self::$msgs[] = array(
            'file' => $file,
            'line' => $line,
            'msg'  => $msg,
            'data' => $data,
            'time' => microtime(true) * 1000,
        );
    }/*}}}*/
}
