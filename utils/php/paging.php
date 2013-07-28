<?php
class Paging
{
    $pageSize = '';

    public function __construct($pageSize = 20)
    {/*{{{*/
        $this->pageSize = $pageSize;
    }/*}}}*/

    public function fixCurrPage($totalItems = 0, $currPage = 1)
    {/*{{{*/
        if ($currPage < 1)
            return 1;
        $totalPage = floor($totalItems/$this->pageSize);
    }/*}}}*/
}
