"settings to let .vimrc be reloadable"{{{
""""""""""""""""""""""""""""
"release autogroup in MyAutoCmd
augroup MyAutoCmd
	autocmd!
augroup END
"release map うまくいかないので停止
"mapclear
"imapclear
"ima<Plug>(neocomplete_start_auto_complete)
"}}}

"basic setting"{{{
""""""""""""""""""""""""""""""
set nocompatible
set modeline
set modelines =3
set ruler "画面右下にカーソル位置表示
set mouse=a "マウスをオン"
"set cursorline "カーソル行の背景色を変える
"set cursorcolumn "カーソル位置のカラムの背景色を変える
set foldmethod=marker
set formatoptions=q "自動で改行を許さない(textwidthを無効？)
set clipboard& clipboard+=unnamedplus,unnamed "clipboardを共有 "optionを初期化してから
set encoding=utf-8
set number "行番号を表示
set nobackup "バックアップファイルの設定
set directory =~/.vimswp//,. "mac以外でも使えるようにdotを追加
set undodir =~/.vimundo~,.
set cmdheight=2
set showmatch
set list
set listchars=tab:▸\ ,eol:↲,extends:❯,precedes:❮
set backspace=indent,eol,start "Backspaceキーの影響範囲に制限を設けない
"set scrolloff=8		"上下8行の視界を確保
set sidescrolloff=16		   " 左右スクロール時の視界を確保
set sidescroll=1		  " 左右スクロールは一文字づつ行う
set hlsearch "検索文字列をハイライトする
set incsearch "インクリメンタルサーチを行う
set ignorecase "大文字と小文字を区別しない
set smartcase "文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
"set gdefault "置換の時 g オプションをデフォルトで有効にする
set wrapscan "最後尾まで検索を終えたら次の検索で先頭に移る
set undofile "undo履歴を保存
set splitright "右に画面を開く
set splitbelow "右に画面を開く
set visualbell t_vb = "ビープ音を消す
"}}}

"tab option"{{{
""""""""""""""""""""""""""""""
"(参考)http://nort-wmli.blogspot.jp/2013/05/vim.html
set noexpandtab "タブを押した時に空白が挿入される。何文字分の空白になるかはsofttabstopの値が使われる。
set tabstop=4 "<TAB>を含むファイルの表示において、タブ文字の表示幅を何文字の空白分にして表示するか.またretabもこの値を利用する。何故か規定のlocal値が4になっている？
set softtabstop=4 "tab を入力するとこの値の分だけ表示が動く様に自動的にtabか空白が挿入される。常に空白が最小 0に設定するとtabstopは無効
set shiftwidth=4 "vimが自動でインデントを行った際、設定する空白数
set autoindent
set smartindent

"}}}

"window setting"{{{
""""""""""""""""""""""""""""""
"右側にwinowが存在すればsp分割、存在しなければvertical分割するコマンド
"右側にwidowが存在する場合
"cursor key でwindowを切り替える。
nnoremap <s-Left> <c-w>h
nnoremap <s-Right> <c-w>l
nnoremap <s-Up> <c-w>k
nnoremap <s-Down> <c-w>j
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
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [filetype=%Y]\ [POS=%04l,%04v]\ [%p%%]\ [amount=%L行]\ [cwd\ %{fnamemodify(getcwd(),':~')}]
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
nmap	   t   [Tag]
"Tab jump:t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
for n in range(1, 9)
	execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

function! s:newtab()
	tabnew
	VimFiler
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
noremap ev :<C-u>edit ~/dotfiles/.vimrc<CR>
noremap gf <C-w>gf
"noremap <C-j> <C-w>gf
"autocmd MyAutoCmd FileType help noremap <buffer> <C-j> <C-]>
"autocmd MyAutoCmd FileType help noremap <buffer> <ESC> :q<CR>
"quickfixでenterでジャンプ
autocmd MyAutoCmd FileType qf noremap <buffer> <Enter> <Enter>
"以下はプラグインの機能を呼び出すから再帰的
" nmap ysiw ysaw
"inormapはインサートモード
"移動系
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <ESC>xi
inoremap <C-h> <Backspace>
inoremap <C-k> <esc>d$<insert>
"nnormapはノーマルモード
nnoremap <Enter> i<Enter><ESC>
"ジャンプ系のコマンド
"noremap ( '
"nnoremap ' <c-o>
"nnoremap ) <c-i>
nnoremap <c-h> <c-o>
nnoremap <c-f> <c-i>
"enterとtabはノーマルモードでも挿入できる様に
nnoremap <C-m> i<return><ESC>
nnoremap <TAB> i<TAB><ESC>l
"nnoremap Q :q<return>
"K,Iで上下にスクロール
" nnoremap K <C-e>
" nnoremap I <C-y>
"K,Iで最上行に飛ぶ
"nnoremap K L
"nnoremap I H
"Lで行頭に挿入
"nnoremap L I
"vmapはヴィジュアルモード
"選択しているwordを検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<CR><CR>

"miscellaneous
"コマンド履歴の呼び出しを自然に
nnoremap q: q:k
"検索後の移動を自然に
nnoremap n nzz
nnoremap N Nzz
"vvで行末まで選択
vnoremap v $ 
"}}}

"set plugins{{{
""""""""""""""""""""""""""""""
"set up neobundle and install plugin"{{{
""""""""""""""""""""""""""""""
filetype off 
if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim
endif
"neobundleの初期化
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
" originalrepos on github
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc.vim', {
			\ 'build' : {
			\		'windows' : 'tools\\update-dll-mingw',
			\		'cygwin' : 'make -f make_cygwin.mak',
			\		'mac' : 'make -f make_mac.mak',
			\		'unix' : 'make -f make_unix.mak',
			\    },
			\ }
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle "Shougo/neosnippet"
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'honza/vim-snippets'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimshell'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-prettyprint'
NeoBundle 'LeafCage/foldCC'
NeoBundle 'LeafCage/yankround.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'kannokanno/vim-helpnew'
NeoBundle 'sjl/gundo.vim'
NeoBundle 't9md/vim-quickhl'
NeoBundle 'nathanaelkane/vim-indent-guides'

" コード補完
" NeoBundle 'marcus/rsense' :helpが正常動作しない (執筆時点) http://qiita.com/uplus_e10/items/27a3dd9e2586ec0f2c2c
NeoBundle 'NigoroJr/rsense' 
NeoBundle 'supermomonga/neocomplete-rsense.vim'
" 静的解析
NeoBundle 'scrooloose/syntastic'
" ドキュメント参照
NeoBundle 'yuku-t/vim-ref-ri'
" メソッド定義元へのジャンプ windowsでコマンドプロンプトのエラーが一瞬出る｡
" NeoBundle 'szw/vim-tags'

"txt_obj => (references) http://qiita.com/rbtnn/items/a47ed6684f1f0bc52906
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'osyo-manga/vim-textobj-multiblock' " i(, i[, i{などをisbで扱える。(一番近いとろこを探す。) aも同様
NeoBundle 'osyo-manga/vim-textobj-multitextobj'
NeoBundle 'sgur/vim-textobj-parameter' "関数の引数 i, a,

NeoBundle 'tyru/caw.vim' "commnet toggle
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'airblade/vim-rooter'
NeoBundle 'tyru/vim-altercmd' "http://qiita.com/kentaro/items/c3f7fc1d1be0e106735b

" Markdown syntax
" NeoBundle 'kannokanno/previm' "markdown 用
NeoBundle "godlygeek/tabular"
NeoBundle "joker1007/vim-markdown-quote-syntax"
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'tyru/open-browser.vim'

NeoBundle 'davidhalter/jedi-vim'
NeoBundleLazy "nvie/vim-flake8", {
			\ "autoload": {
			\	"filetypes": ["python", "python3", "djangohtml"]
			\ }}

NeoBundle 'xolox/vim-session'
NeoBundle 'xolox/vim-misc'
NeoBundle 'othree/html5.vim'
NeoBundle 'hail2u/vim-css3-syntax'
" NeoBundle 'pangloss/vim-javascript'
NeoBundleLazy 'jelera/vim-javascript-syntax', {'autoload':{'filetypes':['javascript']}}
" NeoBundle 'jason0x43/vim-js-indent'
NeoBundle 'vim-scripts/JavaScript-Indent'

NeoBundle 'vim-scripts/ViewOutput'
NeoBundle 'kojinho10/mysetting.vim'
"NeoBundle 'tyru/restart.vim'
"NeoBundle 'git://git.code.sf.net/p/vim-latex/vim-latex' "<c-j>をつぶしていたため一旦削除。使う場合はそこを修正してから。
"NeoBundle 'rhysd/clever-f.vim'

"カラースキームを取得"{{{
NeoBundle 'ujihisa/unite-colorscheme' " カラースキーム一覧表示に Unite.vim を使う
NeoBundle 'altercation/vim-colors-solarized' " solarized カラースキーム
NeoBundle 'croaker/mustang-vim' " mustang カラースキーム
NeoBundle 'jeffreyiacono/vim-colors-wombat' " wombat カラースキーム
NeoBundle 'nanotech/jellybeans.vim' " jellybeans カラースキーム
NeoBundle 'vim-scripts/Lucius' " lucius カラースキーム
NeoBundle 'vim-scripts/Zenburn' " zenburn カラースキーム
NeoBundle 'mrkn/mrkn256.vim' " mrkn256 カラースキーム
NeoBundle 'jpo/vim-railscasts-theme' " railscasts カラースキーム
NeoBundle 'therubymug/vim-pyte' " pyte カラースキーム
NeoBundle 'tomasr/molokai' " molokai カラースキーム
NeoBundle 'w0ng/vim-hybrid' " hybrid カラースキーム
NeoBundle 'daylerees/colour-schemes' "daylerees カラースキーム
NeoBundle 'Lokaltog/vim-distinguished' "distinguishd
"}}}

call neobundle#end()
NeoBundleCheck
"}}}

"colorscheme"{{{
""""""""""""""""""""""""""""""
" 以下のコマンドは :colorscheme の前に設定します
"Searchを変更する。
autocmd MyAutoCmd ColorScheme * highlight Search guibg=#ffffe0 guisp=Red guifg=#DA4939

"guiのcolorscheme
"let gvim_scheme = 'railscasts'
" let gvim_scheme = 'desert'
let gvim_scheme = 'hybrid'
"macvimのgvimrcが邪魔するので.これを書かないと初期画面がrailsにならない。
autocmd MyAutoCmd GUIEnter * execute 'colorscheme' gvim_scheme
"cuiのcolorscheme
if !has('gui_running')
	" let scheme = 'mrkn256'
	let scheme = 'hybrid'
	execute 'colorscheme' scheme
endif
"preview_command
command! PC Unite -auto-preview colorscheme
"command Syntax infoの定義"{{{
function! s:get_syn_id(transparent)
	let synid = synID(line("."), col("."), 1)
	if a:transparent
		return synIDtrans(synid)
	else
		return synid
	endif
endfunction
function! s:get_syn_attr(synid)
	let name = synIDattr(a:synid, "name")
	let ctermfg = synIDattr(a:synid, "fg", "cterm")
	let ctermbg = synIDattr(a:synid, "bg", "cterm")
	let guifg = synIDattr(a:synid, "fg", "gui")
	let guibg = synIDattr(a:synid, "bg", "gui")
	return {
				\ "name": name,
				\ "ctermfg": ctermfg,
				\ "ctermbg": ctermbg,
				\ "guifg": guifg,
				\ "guibg": guibg}
endfunction
function! s:get_syn_info()
	let baseSyn = s:get_syn_attr(s:get_syn_id(0))
	echo "name: " . baseSyn.name .
				\ " ctermfg: " . baseSyn.ctermfg .
				\ " ctermbg: " . baseSyn.ctermbg .
				\ " guifg: " . baseSyn.guifg .
				\ " guibg: " . baseSyn.guibg
	let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
	echo "link to"
	echo "name: " . linkedSyn.name .
				\ " ctermfg: " . linkedSyn.ctermfg .
				\ " ctermbg: " . linkedSyn.ctermbg .
				\ " guifg: " . linkedSyn.guifg .
				\ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()"}}}

"}}}
"Uniteの設定"{{{
""""""""""""""""""""""""""""""
"基本的な設定
let g:unite_source_file_mru_long_limit = 3000
let g:unite_source_directory_mru_long_limit = 3000
let g:unite_source_file_mru_limit = 250
let g:unite_enable_start_insert = 1
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
let g:unite_source_history_yank_enable = 1
"let g:unite_source_rec_max_cache_files = 50000
"call unite#filters#matcher_default#use(['matcher_fuzzy'])
"
call unite#custom_default_action('source/bookmark/directory' , 'vimfiler') "bookmarkはvimfilerと連携

if has("win32") || has("win64")
	let g:unite_source_find_command = "C:/cygwin/bin/find.exe"
endif
" Using ag as recursive command.
" unite grep に ag(The Silver Searcher) を使う
if executable('pt')
	let g:unite_source_grep_command = 'pt'
	let g:unite_source_grep_default_opts = '--nogroup --nocolor --smart-case'
	let g:unite_source_grep_recursive_opt = ''
	let g:unite_source_grep_encoding = 'utf-8'
endif
" grep検索
nnoremap <silent> <Leader>ug  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> <Leader>cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
" grep検索結果の再呼出
nnoremap <silent> <Leader>urg  :<C-u>UniteResume search-buffer<CR>

"開始キーの設定
nnoremap <leader>uf :<C-u>Unite -start-insert file<CR>
nnoremap <leader>ur :<C-u>Unite -start-insert file_rec<CR>
nnoremap <leader>m :<C-u>Unite -start-insert file_mru bookmark file<CR>
nnoremap <leader>p :<C-u>Unite file_rec/async<CR>
nnoremap <leader>c :<C-u>Unite history/yank<CR>
nnoremap <leader>t :<C-u>Unite -start-insert tab<CR>
nnoremap <silent> <leader>b :<C-u>Unite bookmark -start-insert<CR>
"nnoremap <silent> <leader>bp :<C-u>Unite bookmark:project<CR>


" unite.vim上でのキーマッピング
autocmd MyAutoCmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
	"buffer local map は優先度が高いので、<buffer>を付けないとunite defualt mappingを上書き出来ない事に注意
	" nmap <silent><buffer> i <Plug>(unite_loop_cursor_up)
	" nmap <silent><buffer> k <Plug>(unite_loop_cursor_down)
	nmap <silent><buffer> a <Plug>(unite_insert_enter)
	nmap <silent><buffer> <esc> q
	imap <silent><buffer> <Down> <Plug>(unite_select_next_line)
	imap <silent><buffer> <Up> <Plug>(unite_select_previous_line)
	nnoremap <silent><buffer><expr> vf unite#do_action('vimfiler')
	nmap <silent><buffer> t [Tag]
	nmap <silent><buffer> <c-l> :tabnext<cr>

	"unmapしようとするとマップがないと言われる。>> unmap <buffer>でglobalに設定されているmapを削除する事は出来ない
	"これでは改善できない。なぜ？
	"let s:loaded_unmap_escesc = 0
	"if s:loaded_unmap_escesc != 1
	"	 nunmap <buffer> <ESC><ESC>
	"	 let s:loaded_unmap_escesc = 1
	"endif
endfunction
"au MyAutoCmd BufEnter *[unite]* nunmap <esc><esc>
"au MyAutoCmd BufLeave *[unite]* nmap <esc><esc> :nohlsearch<CR>
"au MyAutoCmd BufEnter *.py nunmap <esc><esc>
"}}}
"neocompleteの設定"{{{
""""""""""""""""""""""""""""""
	" Note: This option must set it in .vimrc(_vimrc).
	" NOT IN .gvimrc(_gvimrc)!
	" Disable AutoComplPop.
	let g:acp_enableAtStartup = 0
	" Use neocomplete.
	let g:neocomplete#enable_at_startup = 1
	" Use smartcase.
	let g:neocomplete#enable_smart_case = 1
	let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

	" Define dictionary.
	let g:neocomplete#sources#dictionary#dictionaries = {
	    \ 'default' : '',
	    \ 'vimshell' : $HOME.'/.vimshell_hist',
	    \ 'scheme' : $HOME.'/.gosh_completions'
	    \ }

	" Define keyword.
	if !exists('g:neocomplete#keyword_patterns')
	    let g:neocomplete#keyword_patterns = {}
	endif
	let g:neocomplete#keyword_patterns['default'] = '\h\w*'

	" Plugin key-mappings.
	inoremap <expr><C-g>     neocomplete#undo_completion()
	inoremap <expr><C-l>     neocomplete#complete_common_string()

	" Recommended key-mappings.
	" <CR>: close popup and save indent.
	inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
	function! s:my_cr_function()
	  " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
	  " For no inserting <CR> key.
	  return pumvisible() ? "\<C-y>" : "\<CR>"
	endfunction

	" <TAB>: completion.
	inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
	" <C-h>, <BS>: close popup and delete backword char.
	inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
	inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
	" Close popup by <Space>.
	"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

	" AutoComplPop like behavior.
	"let g:neocomplete#enable_auto_select = 1

	" Shell like behavior(not recommended).
	"set completeopt+=longest
	"let g:neocomplete#enable_auto_select = 1
	"let g:neocomplete#disable_auto_complete = 1
	"inoremap <expr><TAB>  pumvisible() ? "\<Down>" :
	" \ neocomplete#start_manual_complete()

	" Enable omni completion.
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

	" Enable heavy omni completion.
	if !exists('g:neocomplete#sources#omni#input_patterns')
	  let g:neocomplete#sources#omni#input_patterns = {}
	endif
	if !exists('g:neocomplete#force_omni_input_patterns')
	  let g:neocomplete#force_omni_input_patterns = {}
	endif
	"let g:neocomplete#sources#omni#input_patterns.php =
	"\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
	"let g:neocomplete#sources#omni#input_patterns.c =
	"\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
	"let g:neocomplete#sources#omni#input_patterns.cpp =
	"\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

	" For perlomni.vim setting.
	" https://github.com/c9s/perlomni.vim
	let g:neocomplete#sources#omni#input_patterns.perl =
	\ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

	" For smart TAB completion.
	"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
	"        \ <SID>check_back_space() ? "\<TAB>" :
	"        \ neocomplete#start_manual_complete()
	"  function! s:check_back_space() "{{{
	"    let col = col('.') - 1
	"    return !col || getline('.')[col - 1]  =~ '\s'
	"  endfunction"}}}
"}}}
"quickrunの設定"{{{
""""""""""""""""""""""""""""""
" g:quickrun_config の初期化
if !exists("g:quickrun_config")
	let g:quickrun_config={}
endif
" デフォルトの設定
" 非同期で実行
" 出力先
" エラー : quickfix
" 成功	 : buffer
let g:quickrun_config._ = {
			\ "outputter/buffer/split" : ":rightbelow 8sp",
			\ "runner" : "vimproc",
			\ "runner/vimproc/updatetime" : 10,
			\ }
let g:quickrun_config.python = {
			\ "hook/eval/template" : "",
			\ 'command': 'python',
			\}
let g:quickrun_config.applescript= {
			\ 'command': 'osascript',
			\}
let g:quickrun_config.markdown = {
			\ 'outputter' : 'browser',
			\ 'command' : 'pandoc',
			\ 'cmdopt' : '-s -f markdown --template=github',
			\ }
let g:quickrun_config.py = {
			\ }
command! -nargs=0 Pyver let g:quickrun_config.python.command = "python"
command! -nargs=0 Pyver3 let g:quickrun_config.python.command = "python3"

nnoremap <Leader>ll :QuickRun -mode n<CR>
vnoremap <Leader>ll :QuickRun -mode v<CR>	

"pythonとvimrcでquickrunのキーマップを設定
autocmd MyAutoCmd FileType python,vim nnoremap <buffer> <Leader>ll :QuickRun -mode n<CR>
autocmd MyAutoCmd FileType python,vim vnoremap <buffer> <Leader>ll :QuickRun -mode v<CR>
"}}}
"vimshellの設定"{{{
""""""""""""""""""""""""""""""
let g:vimshell_interactive_update_time = 10
let $USERNAME = 'koji'
let g:vimshell_prompt = $USERNAME."% "
let g:vimshell_right_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_interactive_encodings = {
			\'C:/cygwin64/bin/': 'utf-8',
			\}
" vimshell map
nnoremap <silent> <Leader>s :VimShellBufferDir<CR>
" nnoremap <silent> <Leader>p :VimShellPop<CR>
"vimshell上でのキーマッピング
autocmd MyAutoCmd FileType vimshell call s:vimshell_my_settings()
function! s:vimshell_my_settings()
	" nnoremap <silent><buffer>i k
	nmap <silent><buffer> <c-j> :tabprevious<CR>
	nmap <silent><buffer> <c-l> :tabnext<CR>
	imap <silent><buffer> <c-l> <esc><plug>(vimshell_clear)<Plug>(vimshell_insert_enter)
endfunction 
"}}}
"jediの設定"{{{
""""""""""""""""""""""""""""""
"(参考)http://kozo2.hatenablog.com/entry/2014/01/22/050714
",g  go to definition
",d  go to original difinition
"K	 docstring
",r  rename variables
",n  show list of all usage
":Pyimport (module-name)   module-fileを新しいタブで開く
"
autocmd FileType python setlocal omnifunc=jedi#completions
autocmd FileType python setlocal cot=menu,preview "preview-windowを開かないための設定
let g:jedi#auto_initialization = 1
"let g:jedi#popup_select_first = 0
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#show_call_signatures = 0
let g:jedi#popup_on_dot = 1
let g:neocomplete#force_omni_input_patterns = {}
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

"}}}
"vimfilerの設定"{{{
""""""""""""""""""""""""""""""
let g:vimfiler_as_default_explorer = 1

"この変数はexecute_vimfiler_associated(enterにmapping)で何をするかコントロールする。
let g:vimfiler_execute_file_list = {}
let g:vimfiler_execute_file_list = {
			\ "_" : "vim",
			\ "xlsx" : "open",
			\ "xlam" : "open",
			\ "xlsm" : "open"}

call vimfiler#custom#profile('default', 'context', {
     \ 'quit' : 0,
     \ 'safe' : 1,
     \ 'winwidth' : 23,
     \ 'toggle' : 1,
     \ 'simple' : 1,
     \ 'split' : 1,
     \ })

nnoremap <leader>f :<C-u>VimFilerBufferDir<CR>
nnoremap <leader>F :<C-u>VimFiler<CR>

" vimfiler上でのキーマッピング
autocmd MyAutoCmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings()
	"タブ移動,historyとかをつぶしている。
	nmap <silent><buffer> t [tag]
	nnoremap <silent><buffer> [tag]n :TABNEW<CR>
	nnoremap <silent><buffer> [tag]h :tabprevious<CR>
	nnoremap <silent><buffer> [tag]l :tabnext<CR>
	nnoremap <silent><buffer> [tag]q :tabclose<CR>
	nmap <silent><buffer> <c-r> <plug>(vimfiler_redraw_screen)
	"その他
	nmap <silent><buffer> <A-Up> <Plug>(vimfiler_smart_h)
	nmap <silent><buffer> f <Plug>(vimfiler_toggle_mark_current_line)
	nmap <silent><buffer> F <Plug>(vimfiler_toggle_mark_all_lines)
	nmap <silent><buffer> vs <Plug>(vimfiler_mark_current_line)<Plug>(vimfiler_popup_shell)
	nmap <silent><buffer> to <Plug>(vimfiler_choose_action)tabopen<cr>
	nmap <silent><buffer> du <Plug>(vimfiler_switch_to_another_vimfiler)

	nmap <buffer><expr> <CR> vimfiler#smart_cursor_map(
				\  "\<Plug>(vimfiler_cd_file)",
				\  "\<Plug>(vimfiler_edit_file)")
endfunction

"}}}
"clever-fの設定"{{{
""""""""""""""""""""""""""""""
"let g:clever_f_smart_case = 1
"let g:clever_f_use_migemo = 1
"let g:clever_f_across_no_line = 1
"let g:clever_f_show_prompt = 0
"let g:clever_f_not_overwrites_standard_mappings = 1
"map f <Plug>(clever-f-f)
"map F <Plug>(clever-f-F)
"}}}
"easymotionの設定"{{{
""""""""""""""""""""""""""""""
map s <Plug>(easymotion-s2)
map S <Plug>(easymotion-sn)
"map / <Plug>(easymotion-sn)
let g:EasyMotion_keys = 'asdghklweriofj'
let g:EasyMotion_do_shade = 1
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_migemo = 0
hi link EasyMotionTarget2First Comment
hi link EasyMotionTarget2Second Comment
"}}}
"evervimの設定"{{{
""""""""""""""""""""""""""""""
let g:evervim_devtoken = 'S=s12:U=4ebdc3:E=14bf25d788f:C=1449aac4c91:P=1cd:A=en-devtoken:V=2:H=f2fbb78124254141d2f75370f451021e'
" * evervim 
nnoremap <silent> ,el :<C-u>EvervimNotebookList<CR>
nnoremap <silent> ,en :<C-u>EvervimCreateNote<CR>
nnoremap <silent> ,eb :<C-u>EvervimOpenBrowser<CR>
nnoremap ,e/ :<C-u>EvervimSearchByQuery<SPACE>
nnoremap <silent> ,et :<C-u>EvervimSearchByQuery<SPACE>tag:todo -tag:done -tag:someday<CR>
nnoremap <silent> ,eta :<C-u>EvervimSearchByQuery<SPACE>tag:todo -tag:done<CR>
let g:evervim_splitoption=''
let g:evervim_asyncupdate = 1
"}}}
"Vim-LaTeXの設定"{{{
""""""""""""""""""""""""""""""
set shellslash
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Imap_UsePlaceHolders = 1
let g:Imap_DeleteEmptyPlaceHolders = 1
let g:Imap_StickyPlaceHolders = 0
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_FormatDependency_ps = 'dvi,ps'
" place holderを停止
let g:Imap_UsePlaceHolders = 0
let g:Tex_IgnoredWarnings =
			\'Underfull'."\n".
			\'Overfull'."\n".
			\'specifier changed to'."\n".
			\'You have requested'."\n".
			\'Missing number, treated as zero.'."\n".
			\'There were undefined references'."\n".
			\'Citation %.%# undefined'."\n".
			\"Font shape \`JT1/gt/m/it\' undefined"."\n".
			\"Font shape \`JY1/gt/m/it\' undefined"."\n".
			\"Font shape \`JT1/mc/m/it\' undefined"."\n".
			\"Font shape \`JY1/mc/m/it\' undefined"."\n".
			\'LaTeX Font Warning: Some font shapes were not available, defaults substituted.'
let g:Tex_IgnoreLevel = 12
let g:Tex_FormatDependency_pdf = 'dvi,pdf'
let g:Tex_AutoFolding = 0
"let g:Tex_FormatDependency_pdf = 'dvi,ps,pdf'
"let g:Tex_FormatDependency_pdf = 'pdf'
let g:Tex_CompileRule_dvi = 'platex -synctex=1 -interaction=nonstopmode $*'
"let g:Tex_CompileRule_dvi = 'uplatex -synctex=1 -interaction=nonstopmode $*'
let g:Tex_CompileRule_ps = 'dvips -Ppdf -o $*.ps $*.dvi'
let g:Tex_CompileRule_pdf = 'dvipdfmx $*.dvi'
"let g:Tex_CompileRule_pdf = 'ps2pdf $*.ps'
"let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 -interaction=nonstopmode $*'
"let g:Tex_CompileRule_pdf = 'lualatex -synctex=1 -interaction=nonstopmode $*'
"let g:Tex_CompileRule_pdf = 'luajitlatex -synctex=1 -interaction=nonstopmode $*'
"let g:Tex_CompileRule_pdf = 'xelatex -synctex=1 -interaction=nonstopmode $*'
let g:Tex_BibtexFlavor = 'pbibtex'
"let g:Tex_BibtexFlavor = 'upbibtex'
let g:Tex_MakeIndexFlavor = 'mendex $*.idx'
let g:Tex_UseEditorSettingInDVIViewer = 1
let g:Tex_ViewRule_dvi = 'pxdvi -watchfile 1'
"let g:Tex_ViewRule_dvi = 'advi -watch-file 1'
"let g:Tex_ViewRule_dvi = 'evince'
"let g:Tex_ViewRule_dvi = 'okular --unique'
"let g:Tex_ViewRule_dvi = 'wine ~/.wine/drive_c/w32tex/dviout/dviout.exe -1'
let g:Tex_ViewRule_ps = 'gv --watch'
"let g:Tex_ViewRule_ps = 'evince'
"let g:Tex_ViewRule_ps = 'okular --unique'
"let g:Tex_ViewRule_ps = 'zathura'
"let g:Tex_ViewRule_pdf = 'texworks'
"let g:Tex_ViewRule_pdf = 'evince'
"let g:Tex_ViewRule_pdf = 'okular --unique'
"let g:Tex_ViewRule_pdf = 'zathura -s -x "vim --servername synctex -n --remote-silent +\%{line} \%{input}"'
"let g:Tex_ViewRule_pdf = 'qpdfview --unique'
"let g:Tex_ViewRule_pdf = 'pdfviewer'
let g:Tex_ViewRule_pdf = '/usr/bin/open -a Preview.app'
"let g:Tex_ViewRule_pdf = 'gv --watch'
"let g:Tex_ViewRule_pdf = 'acroread'
"let g:Tex_ViewRule_pdf = 'pdfopen -viewer ar9-tab'exの設定
"let g:Tex_ViewRule_pdf = '/Applications/Adobe\ Reader.app'"}}}
"openbrowserの設定"{{{
""""""""""""""""""""""""""""""
" My setting.
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
"}}}
"newhelp.vimの設定"{{{
"""""""""""""""""""""""""""""""
"My setting
let g:helpnew_config = {}
"let g:helpnew_config.command = ''
let g:helpnew_config.command = 'vertical help'
"}}}
"quickhlの設定"{{{
"""""""""""""""""""""""""""""""
nmap <Leader>ht <Plug>(quickhl-manual-this)
nmap <Leader>hr <Plug>(quickhl-manual-reset)
nmap <Leader>hc <Plug>(quickhl-cword-toggle)
nmap <Leader>h] <Plug>(quickhl-tag-toggle)
"}}}
"caw.vimの設定"{{{
"""""""""""""""""""""""""""""""
" \cで行の先頭にコメントをつけたり外したりできる
nmap <Leader>" <Plug>(caw:i:toggle)
vmap <Leader>" <Plug>(caw:i:toggle)
"}}}
"vim-sessionの設定{{{
"""""""""""""""""""""""""""""""
let g:session_autoload = "yes"
let g:session_autosave = "no"
let g:session_default_to_last = 0
let g:session_command_aliases = 1
"}}}
"yankround setting{{{
"""""""""""""""""""""""""""""""
nmap p <Plug>(yankround-p)
xmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
xmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
"}}}
"ruby plugin setting{{{ http://qiita.com/mogulla3/items/42a7f6c73fa4a90b1df3
"""""""""""""""""""""""""""""""
" Rsense
let g:rsenseHome = '/usr/local/lib/rsense-0.3'
let g:rsenseUseOmniFunc = 1
" neocomplete.vim
if !exists('g:neocomplete#force_omni_input_patterns')
	let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.ruby = '[^.*\t]\.\w*\|\h\w*::'
" rubocop
" syntastic_mode_mapをactiveにするとバッファ保存時にsyntasticが走る
" active_filetypesに、保存時にsyntasticを走らせるファイルタイプを指定する
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']
" その他
let g:ref_refe_cmd = $HOME.'/.rbenv/shims/refe' "refeコマンドのパス
" vim-indent-guides
let g:indent_guides_auto_colors=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=110
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=140
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_guide_size=1
"}}}
"snippet setting{{{
"""""""""""""""""""""""""""""""
" http://rcmdnk.github.io/blog/2015/01/12/computer-vim/
if ! empty(neobundle#get("neosnippet"))
	" Plugin key-mappings.
	imap <C-k>     <Plug>(neosnippet_expand_or_jump)
	smap <C-k>     <Plug>(neosnippet_expand_or_jump)
	xmap <C-k>     <Plug>(neosnippet_expand_target)

	"SuperTab like snippets' behavior.
	imap <expr><TAB>
				\ pumvisible() ? "\<C-n>" :
				\ neosnippet#expandable_or_jumpable() ?
				\    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
	smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
				\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

	" For conceal markers.
	if has('conceal')
	  set conceallevel=2 concealcursor=niv
	endif

	let g:neosnippet#enable_snipmate_compatibility = 1
	let g:neosnippet#disable_runtime_snippets = {'_' : 1}
	let g:neosnippet#snippets_directory = ['~/.vim/bundle/neosnippet-snippets/neosnippets']
	let g:neosnippet#snippets_directory += ['~/.vim/bundle/vim-snippets/snippets']
	let g:neosnippet#snippets_directory += ['~/.vim/bundle/mysetting.vim/snippets/']

endif

"}}}
" vim-indent-guides"{{{
let g:indent_guides_auto_colors=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   guibg=red
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  guibg=green
let g:indent_guides_guide_size=1"}}}

"miscellaneous
nnoremap <F5> :GundoToggle<CR>

filetype plugin on
filetype indent on
"}}}

"My Scripts"{{{
""""""""""""""""""""""""""""""
"自分のキーマップを調べるコマンドMYKEYの設定
command! -nargs=+ MYKEY VO verbose <args>
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

"filetypeをpythonに
command! FTP setlocal filetype=python 

"ファイル名変更コマンドを定義
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#')) |w

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


"カーソル下のoptinの値をする
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

"コピー
nnoremap yl ^v$y<esc>
nnoremap yf :let @* = expand("%:p")<CR>
"何故かpで""が選択されない時がある。


"settigs for windows"{{{
"----------------------------
if has("win32") || has("win64")
	inoremap <silent> <esc> <esc>:set iminsert=0<CR>
endif
"}}}
"
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
  let @*=expand('%:P')
endfunction

function! CopyFullPath()
  let @*=expand('%:p')
endfunction

function! CopyFileName()
  let @*=expand('%:t')
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
nnoremap MG :MemoGrep"}}}"}}}

"カスタムコマンドの先頭を小文字にする。"{{{
call altercmd#load()
AlterCommand unite Unite
AlterCommand gstatus Gstatus
AlterCommand path Path
AlterCommand fpath FullPath
AlterCommand vo VO
cd ~/

