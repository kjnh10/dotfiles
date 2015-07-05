#!/bin/sh -e

SCRIPT_DIR=$(dirname $0)

## スクリプトが dotfiles ディレクトリ直下にあると想定
DOTFILES_DIR=$SCRIPT_DIR

function usage() {
    echo "Usage: $0" 1>&2
    exit 1
}
function error() {
    echo "Error: $0 $1" 1>&2
    exit 1
}

## 実行はホームディレクトリでなければならない
if [ "$HOME" != "$(pwd)" ]; then
    error "exec $0 at your home directory: $HOME";
fi

NOW=$(date +%Y%m%d%H%M%S)

function mklink() {
    NAME=$1
    ## 既に同名のファイルが存在する場合はリネーム
    if [ -e "$NAME" ]; then
        mv $NAME ${NAME}.${NOW}
    fi
    DOTFILE=${DOTFILES_DIR}/${NAME}
    echo "mklink $DOTFILE"
    ## Windows の場合は cmd の mklink コマンドを使う
    if [ -n "$WINDIR" ]; then
        if [ -d "$DOTFILE" ]; then
            ## 対象がディレクトリの場合にはジャンクション
            MKLINK_OPTS="/J"
        else
            ## 対象がファイルの場合にはハードリンク
            MKLINK_OPTS="/H"
        fi
        cmd <<< "mklink $MKLINK_OPTS \"${NAME%/}\" \"${DOTFILE%/}\"" > /dev/null
    else
        ln -s $DOTFILE
    fi
}

## .git* 以外の dotfiles をリンク
for F in $(find $DOTFILES_DIR -name '.*' -maxdepth 1 | grep -v '\.git');
do
    NAME=$(basename $F)
    mklink $NAME
done

## 必要な .git* をリンク
for NAME in .gitconfig;
do
    DOTFILE=${DOTFILES_DIR}/${NAME}
    if [ -e "$DOTFILE" ]; then
        mklink $NAME
    fi
done
