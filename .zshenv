#Only this file will be read when a zsh script is executed. So I should do settings , which I expect to work globally,such as PATH settings, in this file rather than .zshrc and .zprofile

#zshは何故かetc/zshenvを読み込んでいない？ので
#if [ -x /usr/libexec/path_helper ]; then
#    eval `/usr/libexec/path_helper -s`
#fi

case ${OSTYPE} in
  darwin*)
    #sdk-toolにパスを通す。
    export PATH=$PATH:/Applications/adt-bundle-mac-x86_64-20130917/sdk/platform-tools
    export PATH=$PATH:/Applications/MacVim.app/Contents/MacOS
    ;;
esac


# echo "source .zshenv"
