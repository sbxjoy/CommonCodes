<?php
class MemCacheDriver
{/*{{{*/
    const FLAG_NO  = false;
    const FLAG_YES = true;

    private $_ins  = null;
    private $_flag = null;

    public function __construct( $servers, $compress_flag = self::FLAG_NO )
    {/*{{{*/
        $this->_ins = new Memcache();
        foreach ( $servers as $s )
        {
            $this->_ins->addServer( $s['host'], $s['port'] );
        }
        $this->_flag = $compress_flag;
    }/*}}}*/

    public function get( $key )
    {/*{{{*/
        return '';
        return $this->_ins->get( $key );
    }/*}}}*/

    public function set( $key, $value, $expire = 86400)
    {/*{{{*/
        LogSvc::getBizLog()->log('set '.$key);
        return $this->_ins->set( $key, $value, $this->_flag, $expire );
    }/*}}}*/

    public function add( $key, $value, $expire )
    {/*{{{*/
        return $this->_ins->add( $key, $value, $this->_flag, $expire );
    }/*}}}*/

    public function replace( $key, $value, $expire )
    {/*{{{*/
        return $this->_ins->replace( $key, $value, $this->_flag, $expire );
    }/*}}}*/
    
    public function delete( $key )
    {/*{{{*/
        LogSvc::getBizLog()->log('del '.$key);
        return $this->_ins->delete( $key );
    }/*}}}*/

    public function flush()
    {/*{{{*/
        LogSvc::getBizLog()->log('flush');
        return $this->_ins->flush();
    }/*}}}*/

    public function increment( $key, $value )
    {/*{{{*/
        return $this->_ins->increment( $key, $value );
    }/*}}}*/

    public function decrement( $key, $value )
    {/*{{{*/
        return $this->_ins->decrement( $key, $value );
    }/*}}}*/

    public function update( $key, $value )
    {/*{{{*/
        $value = (int) $value;
        if ( $value > 0 )
        {
            return $this->increment( $key, $value );
        }
        return $this->decrement( $key, abs( $value ) );
    }/*}}}*/

    public function close()
    {/*{{{*/
        return $this->_ins->close();
    }/*}}}*/

    public function __destruct()
    {/*{{{*/
        $this->close();
    }/*}}}*/
}/*}}}*/
?>
