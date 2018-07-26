augroup MyAutoCmd
	autocmd!
augroup END

"basic setting"{{{
""""""""""""""""""""""""""""""
set nocompatible
set modeline
set modelines =3
set mouse=a "マウスをオン"
set foldmethod=marker
set formatoptions=q "自動で改行を許さない(textwidthを無効？)
set clipboard& clipboard^=unnamedplus,unnamed "clipboardを共有 "optionを初期化してから not + but ^ for linux
set encoding=utf-8
set number "行番号を表示
set nobackup "バックアップファイルの設定
set directory =~/.vimswp//,. "mac以外でも使えるようにdotを追加
set undodir =~/.vimundo~,.
set cmdheight=2
set showmatch
set list
set listchars=tab:¦_,eol:↲,extends:❯,precedes:❮
set backspace=indent,eol,start "Backspaceキーの影響範囲に制限を設けない
set sidescrolloff=16		   " 左右スクロール時の視界を確保
set sidescroll=1		  " 左右スクロールは一文字づつ行う
set hlsearch "検索文字列をハイライトする
set incsearch "インクリメンタルサーチを行う
set ignorecase "大文字と小文字を区別しない
set smartcase "文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
set undofile "undo履歴を保存
set splitright "右に画面を開く
set splitbelow "右に画面を開く
set visualbell t_vb = "ビープ音を消す
"}}}

"tab option"{{{
""""""""""""""""""""""""""""""
"(参考)http://nort-wmli.blogspot.jp/2013/05/vim.html
set expandtab "タブを押した時に空白が挿入される。何文字分の空白になるかはsofttabstopの値が使われる。
set tabstop=2 "<TAB>を含むファイルの表示において、タブ文字の表示幅を何文字の空白分にして表示するか.またretabもこの値を利用する。何故か規定のlocal値が4になっている？
set softtabstop=2 "tab を入力するとこの値の分だけ表示が動く様に自動的にtabか空白が挿入される。常に空白が最小 0に設定するとtabstopは無効
set shiftwidth=2 "vimが自動でインデントを行った際、設定する空白数
set autoindent
"set smartindent "flustrating when commenting in python
set cindent
"}}}

"window setting"{{{
""""""""""""""""""""""""""""""
"commandline windowではwindow移動はできないため
autocmd MyAutoCmd CmdwinEnter * nnoremap <buffer> <Right> <Right>
autocmd MyAutoCmd CmdwinEnter * nnoremap <buffer> <Left> <Left>
autocmd MyAutoCmd CmdwinEnter * nnoremap <buffer> <Up> <Up>
autocmd MyAutoCmd CmdwinEnter * nnoremap <buffer> <Down> <Down>
"}}}

"settings to improve use help system"{{{
""""""""""""""""""""""""""""""
"これ以外にnewhelp.vimの項目を参照
"to open help file
"helpを開く際、通常のwindowの開き方に従う。
set helpheight=0
"helpの開き方を選択するためのコマンド
command! -nargs=? -complete=help RH vertical help <args>
command! -nargs=? -complete=help FH help <args>| only
command! -nargs=? -complete=help TH tab help <args>
"helpをすぐに引くためのコマンド
nnoremap - :HelpNew
nnoremap <S-_> :TH
nnoremap <c-_> :MYKEY
command! -nargs=+ MYKEY VO verbose <args> "自分のキーマップを調べるコマンドMYKEYの設定
  "usage
  "<args> is [n v s x o ! i l c]map [{lhs}].
  "	  ノーマル	ビジュアル+選択  演算待ち状態~
  "map	   yes		  yes	 yes
  "nmap	   yes		   -	  -
  "vmap		-	  yes		  -
  "omap		-	   -		 yes
  "		 ビジュアル  選択
  "vmap		  yes	 yes
  "xmap		  yes	  -
  "smap		   -	 yes
  "
  "		  挿入	コマンドライン Lang-Arg
  "map!		  yes	 yes	 -
  "imap		  yes	  -		 -
  "cmap		   -	 yes	 -
  "lmap		  yes*	 yes*		yes*

"Hでhelpをひく
nnoremap <expr>H ':HelpNew '.expand('<cword>').'<CR>'
vnoremap <expr>H '"vy:HelpNew <C-r>"<CR>'
"Kで実行されるコマンドをhelpにする。ただしKは現在remappされている事に注意
set keywordprg=:help
"on help files
"Enterでタグジャンプ
autocmd MyAutoCmd FileType help nnoremap <buffer> <Enter> <C-]>
autocmd MyAutoCmd FileType help nnoremap <buffer> W :setlocal wrap!<CR>
autocmd MyAutoCmd FileType help setlocal sidescroll=1
autocmd MyAutoCmd FileType help setlocal tabstop=4
"}}}

"statusLine"{{{
""""""""""""""""""""""""""""""
set laststatus=2 "ステータス行を常に表示
set statusline=%F%m%r%h%w\ [cwd\ %{fnamemodify(getcwd(),':~')}]\ [filetype=%Y]\ [FORMAT=%{&ff}]
"change statusline color while insert mode"{{{
""""""""""""""""""""""""""""""
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'
if has('syntax')
	augroup InsertHook
		autocmd!
		autocmd InsertEnter * call s:StatusLine('Enter')
		autocmd InsertLeave * call s:StatusLine('Leave')
	augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
	if a:mode == 'Enter'
		silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
		silent exec g:hi_insert
	else
		highlight clear StatusLine
		silent exec s:slhlcmd
	endif
endfunction

function! s:GetHighlight(hi)
	redir => hl
	exec 'highlight '.a:hi
	redir END
	let hl = substitute(hl, '[\r\n]', '', 'g')
	let hl = substitute(hl, 'xxx', '', '')
	return hl
endfunction
"}}}
"}}}

"move through tab"{{{
""""""""""""""""""""""""""""""
"Anywhere SID.
function! s:SID_PREFIX()
	return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

"タブラインの表示(tablineオプション)設定
function! s:my_tabline()
	let s = ''
	for i in range(1, tabpagenr('$'))
		let bufnrs = tabpagebuflist(i)
		let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
		let no = i	" display 0-origin tabpagenr.
		let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
		let title = fnamemodify(bufname(bufnr), ':t')
		let title = '[' . title . ']'
		let s .= '%'.i.'T'
		let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
		let s .= no		. ':' . title
		let s .= mod
		let s .= '%#TabLineFill# '
	endfor
	let s .= '%#TabLineFill#%T%=%#TabLine#'
	return s
endfunction
"tablineが使われるのはCUIだけ
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

"keymapping
"The prefix key.
nnoremap [Tag] <Nop>
nnoremap [MoveTag] <Nop>
nmap	   t   [Tag]
nmap	   T   [MoveTag]
"Tab jump:t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
for n in range(1, 9)
	execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

function! s:newtab()
  try
    cd %:h
  catch
  endtry
	tabnew
	" VimFiler
endfunction

command! TABNEW call s:newtab()
" tn 新しいタブを一番右に作る
" map <silent> [Tag]n :tablast <bar> tabnew<CR>
map <silent> [Tag]n :TABNEW<CR>
"tq タブを閉じる
map <silent> [Tag]q :tabclose<CR>
"tl 次のタブ
map <silent> [Tag]l :tabnext<CR>
"tj 前のタブ
map <silent> [Tag]h :tabprevious<CR>
"tl 一番右のタブ
map <silent> [Tag]L :tablast<CR>
"tl 一番左のタブ
map <silent> [Tag]H :tabfirst<CR>

map <silent> [MoveTag]h :tabm -1<CR>
map <silent> [MoveTag]l :tabm +1<CR>
map <silent> [MoveTag]H :tabm 0<CR>
map <silent> [MoveTag]L :tabm<CR>

noremap <silent> <C-Right> :tabnext<CR>
tnoremap <silent> <C-Right> <C-\><C-n>:tabnext<CR>
noremap <silent> <C-Left> :tabprevious<CR>
tnoremap <silent> <C-Left> <C-\><C-n>:tabprevious<CR>
"}}}

"basic keymapping setting"{{{
""""""""""""""""""""""""""""""
let mapleader = ","
"noremapはノーマル＋ヴィジュアルモード＋演算待機モード
"移動系
noremap <C-a> ^
noremap <C-e> <End>
noremap j gj
noremap k gk
" noremap ev :<C-u>edit $MYVIMRC<CR>
noremap ev :<C-u>edit ~/.config/nvim/init.vim<CR>
noremap gf <C-w>gf

"quickfixでenterでジャンプ
autocmd MyAutoCmd FileType qf noremap <buffer> <Enter> <Enter>

"enterとtabはノーマルモードでも挿入できる様に
nnoremap <Enter> i<Enter><ESC>
nnoremap <C-m> i<return><ESC>
nnoremap <TAB> i<TAB><ESC>l

"選択しているwordを検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>

"miscellaneous
"コマンド履歴の呼び出しを自然に
nnoremap q: q:k
"検索後の移動を自然に
nnoremap n nzz
nnoremap N Nzz

imap <Nul> <C-Space>
"}}}

"set plugins{{{
""""""""""""""""""""""""""""""
"dein Scripts-----------------------------{{{
  " dein自体の自動インストール
  let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
  let s:dein_dir = s:cache_home . '/dein'
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
  endif
  let &runtimepath = s:dein_repo_dir .",". &runtimepath
  " プラグイン読み込み＆キャッシュ作成
  let s:toml_file = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
  "if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#load_toml(s:toml_file)
    call dein#end()
    call dein#save_state()
  "endif

  " Required:
  filetype plugin indent on
  syntax enable

  " 不足プラグインの自動インストール
  if has('vim_starting') && dein#check_install()
    call dein#install()
  endif
"End dein Scripts-------------------------}}}
let g:deoplete#enable_at_startup = 1"}}}

"My Scripts{{{
""""""""""""""""""""""""""""""
"%で対応するタグに移動
source $VIMRUNTIME/macros/matchit.vim

"ESCを二回押す事でハイライトを消す
nmap <silent> <ESC><ESC> :nohlsearch<CR>

"QuickFix及びHelpではQでバッファを閉じる
autocmd MyAutoCmd FileType help,QuickFix nnoremap <buffer> Q <C-w>c

"カレントディレクトリを編集中のファイルの存在するディレクトリに変更するコマンドCD
command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>')
function! s:ChangeCurrentDir(directory, bang)
	if a:directory == ''
		lcd %:p:h
	else
		execute 'lcd' . a:directory
	endif
	if a:bang == ''
		pwd
	endif
endfunction
" Change current directory.

"vimrcの変更を自動で反映(.gvimrcも参照)
if !has('gui_running') && !(has('win32') || has('win64'))
	"terminalの場合
	autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
else
	"mac_vimかwindowsのgvimの場合
	autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC| source $MYGVIMRC
endif

"カーソル下のoptinの値を取得する
nnoremap <expr> <f1> ':echo &'.expand(GetOptionUnderCursor()).'<CR>'
nnoremap <expr> <s-f1> ':VO echo &'.expand(GetOptionUnderCursor()).'<CR>'
function! GetOptionUnderCursor()
	let l:line = getline('.')
	let l:col_pos_in_line = getpos('.')[2]
	let l:start = strridx(l:line,"'",l:col_pos_in_line)
	let l:end = stridx(l:line,"'",l:col_pos_in_line)
	if l:start != -1 && l:end != -1
		let l:string = l:line[l:start+1 : l:end-1]
		echo l:string
		return l:string
	else
		echo "カーソル下がoptionではありません!"
	endif
endfunction

"カーソル下の変数の値を取得する
nnoremap <expr> <f2> ':echo '.expand('<cword>').'<CR>'

"settigs for windows"{{{
"----------------------------
if has("win32") || has("win64")
	inoremap <silent> <esc> <esc>:set iminsert=0<CR>
endif
"}}}

"experimental settings{{{
"----------------------------

"text-object-sample:a fold
vnoremap af :<C-U>silent! normal! [zV]z<CR>
omap af :normal Vaf<CR>

"command range test-setting
command! -nargs=0 -range=0 -range=% Rangetest :echo <count> <line1> <line2>
command! -nargs=0 -count=0 Counttest :echo <count> <line1> <line2>


"unite source created by own"{{{
"----------------------------------------------
let source = {
			\ 'name' : 'sample',
			\ 'description' : 'this is sample source',
			\ 'action_table' : {},
			\ 'max_candidates' : 1000,
			\ }

call unite#define_source(source)

function! source.gather_candidates(args, context)
	let candidates = []
	"write the code that gather candidates.
	"
	return candidates
endfunction"}}}
"}}}

"copy path"{{{
function! CopyPath()
  let res = expand('%:P')
  let @*=res
  let @+=res
endfunction

function! CopyFullPath()
  let res = expand('%:p')
  let @*=res
  let @+=res
endfunction

function! CopyFileName()
  let res = expand('%:t')
  let @*=res
  let @+=res
endfunction

command! Path     call CopyPath()
command! FullPath call CopyFullPath()
command! FileName call CopyFileName()

nnoremap <silent>cp :Path<CR>
nnoremap <silent>cfp :FullPath<CR>
nnoremap <silent>cf :FileName<CR>"}}}

"memo機能"{{{
"http://tekkoc.tumblr.com/post/41943190314/%E7%A7%92%E9%80%9F%E3%81%A7vim%E3%81%A7%E3%83%A1%E3%83%A2%E3%82%92%E6%9B%B8%E3%81%8F%E6%9D%A1%E4%BB%B6
function! s:open_memo_file()"
    let l:category = input('Category: ')
    let l:title = input('Title: ')

    if l:category == ""
        let l:category = "other"
    endif

    let l:memo_dir = $HOME . '/Dropbox/Memo/vim/' . l:category
    if !isdirectory(l:memo_dir)
        call mkdir(l:memo_dir, 'p')
    endif

    let l:filename = l:memo_dir . strftime('/%Y-%m-%d_') . l:title . '.txt'

    let l:template = [
                \'Category: ' . l:category,
                \'========================================',
                \'Title: ' . l:title,
                \'----------------------------------------',
                \'date: ' . strftime('%Y/%m/%d %T'),
                \'- - - - - - - - - - - - - - - - - - - - ',
                \'',
                \]

    " ファイル生成
    execute 'tabnew ' . l:filename
    call setline(1, l:template)
    execute '999'
    execute 'write'
endfunction augroup END"


" メモを作成するコマンド
command! -nargs=0 MemoNew call s:open_memo_file()
" メモ一覧をUniteで呼び出すコマンド
command! -nargs=0 MemoList :Unite file_rec:~/Dropbox/Memo/ -buffer-name=memo_list
" メモ一覧をUnite grepするコマンド
command! -nargs=0 MemoGrep :Unite grep:~/Dropbox/Memo/ -no-quit
" メモ一覧をVimFilerで呼び出すコマンド
command! -nargs=0 MemoFiler :VimFiler ~/Dropbox/Memo

" メモ関連マッピング
nnoremap Mn :MemoNew
nnoremap Ml :MemoList
nnoremap Mf :MemoFiler
nnoremap Mg :MemoGrep

" シフト押したままでもマッピングが起動するように
nnoremap MN :MemoNew
nnoremap ML :MemoList
nnoremap MF :MemoFiler
nnoremap MG :MemoGrep"}}}

"grep
autocmd QuickFixCmdPost *grep* cwindow

"http://deris.hatenablog.jp/entry/2013/05/15/024932
nnoremap /  /\v

autocmd BufEnter * silent! lcd %:p:h  "https://vi.stackexchange.com/questions/14519/how-to-run-internal-vim-terminal-at-current-files-dir

" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>

" terminal setting
noremap <Leader>to :vertical :T cd %:h<CR>
if has('nvim')
  " Neovim 用
  autocmd WinEnter * if &buftype ==# 'terminal' | startinsert | endif
else
  " Vim 用
  autocmd WinEnter * if &buftype ==# 'terminal' | normal i | endif
endif

"neovim setting
if has('nvim')
  tnoremap <C-n> <C-\><C-n>
  tnoremap <C-w> <C-\><C-n><C-w>
  set guicursor=  "ref: https://github.com/neovim/neovim/issues/6691 for terminator
endif

"}}}
