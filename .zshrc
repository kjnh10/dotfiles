echo "start source .zshrc"
#default on

# ------------------------------
# General Settings
# ------------------------------
#macvimkaoriyaの設定
#export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
#alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
#alias mvim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -g"$@"' 
export VMAIL_VIM="/Applications/MacVim.app/Contents/MacOS/Vim"


export EDITOR=vim        # エディタをvimに設定
export LANG=ja_JP.UTF-8  # 文字コードをUTF-8に設定
export KCODE=u           # KCODEにUTF-8を設定
export AUTOFEATURE=true  # autotestでfeatureを動かす

bindkey -e               # キーバインドをemacsモードに設定
#bindkey -v              # キーバインドをviモードに設定

setopt nolistbeep           # ビープ音を鳴らさないようにする
setopt auto_cd           # ディレクトリ名の入力のみで移動する 
setopt auto_pushd        # cd時にディレクトリスタックにpushdする
setopt correct           # コマンドのスペルを訂正する
setopt magic_equal_subst # =以降も補完する(--prefix=/usrなど)
setopt prompt_subst      # プロンプト定義内で変数置換やコマンド置換を扱う
setopt notify            # バックグラウンドジョブの状態変化を即時報告する
setopt equals            # =commandを`which command`と同じ処理にする

### Complement ###
autoload -U compinit; compinit # 補完機能を有効にする
setopt auto_list               # 補完候補を一覧で表示する(d)
setopt auto_menu               # 補完キー連打で補完候補を順に表示する(d)
setopt list_packed             # 補完候補をできるだけ詰めて表示する
setopt list_types              # 補完候補にファイルの種類も表示する
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない

### Glob ###
setopt extended_glob # グロブ機能を拡張する
unsetopt caseglob    # ファイルグロブで大文字小文字を区別しない

### History ###
HISTFILE=~/.zsh_history   # ヒストリを保存するファイル
HISTSIZE=10000            # メモリに保存されるヒストリの件数
SAVEHIST=10000            # 保存されるヒストリの件数
setopt bang_hist          # !を使ったヒストリ展開を行う(d)
setopt extended_history   # ヒストリに実行時間も保存する
setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに追加しない
setopt share_history      # 他のシェルのヒストリをリアルタイムで共有する
setopt hist_reduce_blanks # 余分なスペースを削除してヒストリに保存する

# マッチしたコマンドのヒストリを表示できるようにする
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# すべてのヒストリを表示する
function history-all { history -E 1 }

# ------------------------------
# Look And Feel Settings
# ------------------------------
### Ls Color ###
# 色の設定
export LSCOLORS=Exfxcxdxbxegedabagacad
# 補完時の色の設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# ZLS_COLORSとは？
export ZLS_COLORS=$LS_COLORS
# lsコマンド時、自動で色がつく(ls -Gのようなもの？)
export CLICOLOR=true
# 補完候補に色を付ける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

### Prompt ###
# プロンプトに色を付ける
autoload -U colors; colors

GIT_PS1_SHOWCOLORHINTS=true
PROMPT2='[%n]> ' 
#gitのステータスを表示
#(参考)https://www.udacity.com/course/viewer#!/c-ud775/l-2980038599/m-2955818665
source .git-prompt.sh 
setopt PROMPT_SUBST ; PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '

# ------------------------------
# Other Settings
# ------------------------------
### RVM ###
if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi

### Aliases ###
alias r=rails
#alias v=vim
#alias mvim='/Applications/MacVim.app/Contents/MacOS/vim -g'

#zshcompletionの設定
fpath=(/usr/local/share/zsh $fpath)

case ${OSTYPE} in
    darwin*)
        #ここにMac向けの設定
		alias ctags="`brew --prefix`/bin/ctags" #https://gist.github.com/nazgob/1570678
		;;
    linux*)
        #ここにLinux向けの設定
		;;
esac
#cygwinの設定
if [[ $OSTYPE == cygwin* ]];then # スペース入れないとエラーになる。
	export PATH=~/bin:/usr/local/sbin:/usr/local/bin:/sbin:/usr/sbin:/usr/bin:$PATH # findなどがosのものより先に来てしまっているので。
	#railsの設定
	#http://shiroibanana.blogspot.jp/2014/08/ruby-on-railshello-world.html
	alias rails='rails.bat'
	alias gem='gem.bat'
	alias rake='rake.bat'
	alias erb='erb.bat'
	alias irb='irb.bat'
	alias rdoc='rdoc.bat'
	alias ri='ri.bat'
	alias rspec='rspec.bat'
	alias cucumber='cucumber.bat'
	alias bundle='bundle.bat'

	#git の文字化け対策 http://d.hatena.ne.jp/Rion778/20091107/1257623615
	export LANG=ja_JP.UTF-8
	export PAGER="lv -Ou8"

	#go
	export GOPATH="C:\Users\bc0074854\go"
	export PATH=$PATH:$GOPATH/bin

	#ruby
	export PATH="$HOME/.rbenv/bin:$PATH"
	eval "$(rbenv init - zsh)"
fi

echo "ended source .zshrc"
