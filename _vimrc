set t_Co=256
"colorscheme desert
"语法高亮
syntax on
"智能缩进
set smartindent
"自动对齐
set autoindent
"自动备份
if has("vms")
      set nobackup	
else	  
    set backup
endif
"在右下角显示当前光标位置
set ruler
"在右下角显示当前已输入但还未执行的命令
set showcmd
"自动识别文件类型，用文件类型的plugin脚本，用对应的缩进定义
filetype plugin indent on
"缩进量
set tabstop=4
"缩进值，和tabstop什么关系？我也没搞清楚，反正我的这两个值是相同的
set shiftwidth=4
"把制表符换为空格
set expandtab
"搜索追踪
set incsearch
"强制将文件编码转为utf8
set fileencoding=utf8
"当前终端输入的编码
set encoding=utf8
"按照折叠符号折叠
set foldmethod=marker
"行首显示折叠标识的空格数
set foldcolumn=2
"备份文件目录
set backupdir=~/backup/vim
"备份文件扩展名
set backupext=.bak
"显示对应的半个括号位置
set showmatch
"显示行号
set nu
"设置背景为暗色
set background=dark
"如果找Cscope数据库失败时，不要报错
set nocscopeverbose
"自动折行
set wrap
"帮助文档语言
set helplang=cn

"选择快捷键组
map vi' <Esc>?'<CR>lv/'<CR>h
map vi" <Esc>?"<CR>lv/"<CR>h
map va' <Esc>?'<CR>v/'<CR>
map va" <Esc>?"<CR>v/"<CR>
map vix <Esc>?><CR>lv/<<CR>h
map vi= <ESC>?\s\+\S\+\s*=\s*\S\+<CR>lv/=<CR>/\S<CR>/[\s<>\n]<CR>h
map vi/ <Esc>?\/<CR>l<Esc>v/\/<CR>h
map vt) <ESC>v/)<CR>h
map vt' <ESC>v/'<CR>h
map vt" <ESC>v/"<CR>h
map vt; <ESC>v/;<CR>h
map vt, <ESC>v/,<CR>h
map vt} <ESC>v/}<CR>h

"用\q呼起project插件
nmap <silent> <Leader>q <Plug>ToggleProject

"调整窗口高度
map <leader>hl :res +10<CR>
map <leader>hm :res -10<CR>
"调整窗口宽度
map <leader>wl :vertical res +10<CR>
map <leader>wm :vertical res -10<CR>

set csto=0
"set aw
"
autocmd FileType php :call PhpKeys()

function! PhpKeys()
    "调整窗口高度
    map <leader>hl :res +40<CR>
    map <leader>hm :res -40<CR>
    "调整窗口宽度
    map <leader>wl :vertical res +40<CR>
    map <leader>wm :vertical res -40<CR>
    "php文件的缩进
    "let php_folding = 1
endfunction

noremap \dc <Esc>:Dox<CR>
noremap \dd <Esc>:DoxUndoc<CR>
noremap \da <Esc>:DoxAuthor<CR>

"多标签，感觉没什么太大用处
if v:version >= 700
    :map <C-w>p :tabprevious<cr>
    :map <C-w>n :tabnext<cr>
"    :imap <C-w>p <ESC>:tabprevious<cr>i
"    :imap <C-w>x <ESC>:tabnext<cr>i
    :nmap <C-w>t :tabnew<cr>
endif

nmap <leader>ff :cs find t <C-R>=expand("<cword>")<CR><CR>
" ============= PHP FUNCTION BEGIN ========== 
set dictionary-=~/.vim/doc/funclist.txt dictionary+=~/.vim/doc/funclist.txt
set complete-=k complete+=k
function! InsertTabWrapper()
    let col=col('.')-1
    if !col || getline('.')[col-1] !~ '\k'
        return "\<TAB>"
    else
        return "\<C-N>"
    endif
endfunction
inoremap <TAB> <C-R>=InsertTabWrapper()<CR>
" ============= PHP FUNCTION END ========== 