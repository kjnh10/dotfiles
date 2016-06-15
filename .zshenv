#Only this file will be read when a zsh script is executed. So I should do settings , which I expect to work globally,such as PATH settings, in this file rather than .zshrc and .zprofile

#zshは何故かetc/zshenvを読み込んでいない？ので
#if [ -x /usr/libexec/path_helper ]; then
#    eval `/usr/libexec/path_helper -s`
#fi

case ${OSTYPE} in
	darwin*)
		#Homebrewに優先的にパスを通す。
		export PATH=/usr/local/bin:/usr/local/sbin:$PATH
		
		#sdk-toolにパスを通す。
		export PATH=$PATH:/Applications/adt-bundle-mac-x86_64-20130917/sdk/platform-tools
		export PATH=$PATH:/Applications/MacVim.app/Contents/MacOS
		#pnadoc
		export PATH=$PATH:$HOME/.cabal/bin

		#python
		# pyenv
		export PATH="$HOME/.pyenv/bin:$PATH"
		eval "$(pyenv init -)"
		eval "$(pyenv virtualenv-init -)"
		export LC_ALL='ja_JP.UTF-8' #

		;;
	cygwin*)
		#python
			#export WORKON_HOME=~/.virtualenvs
			#export VIRTUALENVWRAPPER_PYTHON=/cygdrive/c/tools/python2/python.exe こんなpathはないと怒られるので保留
			#source /cygdrive/c/tools/python2/Scripts/virtualenvwrapper.sh
		;;
esac
		

echo "source .zshenv"
