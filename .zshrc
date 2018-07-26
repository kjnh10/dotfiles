echo "start source .zshrc"
#default on
#
# ohmyzsh
	export ZSH=$HOME/.oh-my-zsh
	ZSH_THEME="robbyrussell"
	plugins=(git)
	source $ZSH/oh-my-zsh.sh

# ------------------------------
# General Settings
# ------------------------------

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
# ### Ls Color ###
# # 色の設定
# export LSCOLORS=Exfxcxdxbxegedabagacad
# # 補完時の色の設定
# export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# # ZLS_COLORSとは？
# export ZLS_COLORS=$LS_COLORS
# # lsコマンド時、自動で色がつく(ls -Gのようなもの？)
# export CLICOLOR=true
# # 補完候補に色を付ける
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#
# ### Prompt ###
# # プロンプトに色を付ける
# autoload -U colors; colors
#
# GIT_PS1_SHOWCOLORHINTS=true
# PROMPT2='[%n]> ' 
# #gitのステータスを表示
# #(参考)https://www.udacity.com/course/viewer#!/c-ud775/l-2980038599/m-2955818665
# source ~/.git-prompt.sh 
# setopt PROMPT_SUBST ; PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '

# ------------------------------
# Other Settings
# ------------------------------
### RVM ###
if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi

### Aliases ###
alias r=rails
alias vim='nvim'

#zshcompletionの設定
fpath=(/usr/local/share/zsh $fpath)

# SET PATH
  case ${OSTYPE} in
      darwin*)
        #ここにMac向けの設定
        export PATH=/usr/local/bin:$PATH  # homebrew path
        alias ctags="`brew --prefix`/bin/ctags" #https://gist.github.com/nazgob/1570678
        ;;

      linux*)
        export PATH=$HOME/.nodebrew/current/bin:$PATH
        export PATH=$HOME/bin/node-v8.9.4-linux-x64/bin:$PATH
        ;;
  esac

  export PATH=~/bin:$PATH
  #go
  export GOPATH=${HOME}"/go"
  export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH

  # pyenv
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"

  #ruby
  export RBENV_ROOT="$HOME/.rbenv"
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"

#cygwinの設定
if [[ $OSTYPE == cygwin* ]];then # スペース入れないとエラーになる。
    export PATH=usr/local/sbin:/usr/local/bin:/sbin:/usr/sbin:/usr/bin:$PATH # findなどがosのものより先に来てしまっているので。
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

    #ruby
    export PATH="$HOME/.rbenv/bin:$PATH"
fi

# peco setting # {{{
# peco source
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd '${selected_dir}'"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

#pecoでhistory検索
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# ### search a destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}
### search a destination from cdr list and cd the destination
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^x' peco-cdr

# cdr, add-zsh-hook を有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
 
# cdr の設定
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

#pecoでkill
function peco-pkill() {
  for pid in `ps aux | peco | awk '{ print $2 }'`
  do
    kill $pid
    echo "Killed ${pid}"
  done
}
alias pk="peco-pkill"
# }}}
echo "ended source .zshrc"
