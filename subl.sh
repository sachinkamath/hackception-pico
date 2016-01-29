#!/bin/bash

#Sublime Text 3 Linux Bash Installer
#Created by esteban@attitude.cl
#Licensed under WTFPL (Do What The Fuck You Want To Public License)
#http://en.wikipedia.org/wiki/WTFPL

# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                   Version 2, December 2004
#
#Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
#
#Everyone is permitted to copy and distribute verbatim or modified
#copies of this license document, and changing it is allowed as long
#as the name is changed.
#
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
# 0. You just DO WHAT THE FUCK YOU WANT TO.

#Usage:
#	chmod +x ./st3install && sudo ./st3install
#You can upgrade an installation made by this same script, using this
#very same script too ;)

#Esta es la URL que buscaremos en la pagina de descarga
STDOWNLOADURLLIKE="http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_"

#Busquemos la ultima version de Sublime Text 3 en la web directamente
STURLTOCHECK="`wget -qO- http://www.sublimetext.com/3`"

#Home del usuario (http://stackoverflow.com/questions/7358611/bash-get-users-home-directory-when-they-run-a-script-as-root)
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

echo -e "\e[7m*** Sublime Text 3 Batch Installer/Upgrader (esteban@attitude.cl)\e[0m"

#URL distinta segun sistema 64 o 32 bits
if [ "i686" = `uname -m` ]; then
	#http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3000_x32.tar.bz2
	echo -e "\e[7m*** System x86 detected.\e[0m"
	#URLS="`grep -Po '(?<=href=").*?(?=">)' <<<"$STURLTOCHECK"`"
	URL="`grep -Po '(?<=href="http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_)(.*?)(\w+x32.tar.bz2)(?=">)' <<<"$STURLTOCHECK"`"
elif [ "x86_64" = `uname -m` ]; then
	#http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3000_x64.tar.bz2
	echo -e "\e[7m*** System x86_64 detected.\e[0m"
	URL="`grep -Po '(?<=href="http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_)(.*?)(\w+x64.tar.bz2)(?=">)' <<<"$STURLTOCHECK"`"
fi

#El nombre del archivo y la URL completa, la necesitamos para despues
THEFILE="sublime_text_3_build_$URL"
THEDOWNLOADURL="$STDOWNLOADURLLIKE$URL"

echo -e "\e[7m*** I will download and install $THEDOWNLOADURL for you :)\e[0m"

#Instalamos Sublime Text 3
echo -e "\e[7m*** Creating temp location on /var/cache/...\e[0m"
mkdir -p /var/cache/sublime-text-3
cd /var/cache/sublime-text-3

#A la flash-installer
APT_PROXIES=$(apt-config shell http_proxy Acquire::http::Proxy https_proxy Acquire::https::Proxy ftp_proxy Acquire::ftp::Proxy)
if [ -n "$APT_PROXIES" ]; then
	eval export $APT_PROXIES
fi

#Descargamos
echo -e "\e[7m*** Downloading file to temp location...\e[0m"
#http://unix.stackexchange.com/questions/37507/what-does-do-here
:> wgetrc
echo "noclobber = off" >> wgetrc
echo "dir_prefix = ." >> wgetrc
echo "dirstruct = off" >> wgetrc
echo "verbose = on" >> wgetrc
echo "progress = bar:default" >> wgetrc
echo "tries = 3" >> wgetrc
WGETRC=wgetrc wget --continue -O "$THEFILE" "$THEDOWNLOADURL" \
	|| echo -e "\e[7m***Download failed.\e[0m"
	rm -f wgetrc
echo -e "\e[7m*** Download completed.\e[0m"

echo -e "\e[7m*** Unpacking files on temp location...\e[0m"
tar xvf "$THEFILE" || echo -e "\e[7m*** Cannot unpack downloaded file.\e[0m"

echo -e "\e[7m*** Installing Sublime Text 3 into /opt/sublime_text_3/\e[0m"
mkdir -p /opt/sublime_text_3/
cp -rf "/var/cache/sublime-text-3/sublime_text_3/"* /opt/sublime_text_3/

echo -e "\e[7m*** Creating symlinks to /usr/bin/sublime_text\e[0m"
ln -sf /opt/sublime_text_3/sublime_text /usr/bin/sublime_text
ln -sf /opt/sublime_text_3/sublime_text /usr/bin/sublime-text-3
ln -sf /opt/sublime_text_3/sublime_text /usr/bin/st3
ln -sf /opt/sublime_text_3/sublime_text /usr/bin/subl
ln -sf /opt/sublime_text_3/sublime_text /usr/bin/sublime

echo -e "\e[7m*** Creating symlinks for icons on /usr/share/icons/hicolor/...\e[0m"
ln -sf /opt/sublime_text_3/Icon/128x128/sublime-text.png /usr/share/icons/hicolor/128x128/apps/sublime-text-3.png
ln -sf /opt/sublime_text_3/Icon/256x256/sublime-text.png /usr/share/icons/hicolor/256x256/apps/sublime-text-3.png
gtk-update-icon-cache /usr/share/icons/hicolor

echo -e "\e[7m*** Cleaning up temp unpacked files...\e[0m"
rm -rf "/var/cache/sublime-text-3/sublime_text_3/"
rm -rf "/var/cache/sublime-text-3/"*.bz2

#Creando archivo .desktop
echo -e "\e[7m*** Creating .desktop file (for easy launch and associate to Sublime Text 3)...\e[0m"
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Sublime Text 3
GenericName=Text Editor
Comment=Sophisticated text editor for code, markup and prose
#Exec=/opt/sublime_text_3/sublime_text %F
Exec=sublime-text-3 %F
Terminal=false
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/xml;text/html;text/css;text/x-sql;text/x-diff;x-directory/normal;inode/directory;
Icon=sublime-text-3
Categories=TextEditor;Development;
StartupNotify=true
Actions=Window;Document;

[Desktop Action Window]
Name=New Window
Exec=/opt/sublime_text_3/sublime_text -n
OnlyShowIn=Unity;

[Desktop Action Document]
Name=New File
Exec=/opt/sublime_text_3/sublime_text --command new_file
OnlyShowIn=Unity;" > /usr/share/applications/"Sublime Text 3.desktop"

#Porque necesitamos correr el comando como el usuario y no como root, usaremos:
#http://superuser.com/questions/93385/run-part-of-a-bash-script-as-a-different-user
#http://superuser.com/questions/195781/sudo-is-there-a-command-to-check-if-i-have-sudo-and-or-how-much-time-is-left
CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1|grep "load"|wc -l)
if [ ${CAN_I_RUN_SUDO} -gt 0 ]; then
	#Podemos correr sudo
	#Instalar Package Control https://sublime.wbond.net/installation
	echo -e "\e[7m*** Installing Package Control (check https://sublime.wbond.net/ for more awesomeness)...\e[0m"
	sudo -u $SUDO_USER mkdir -p "$USER_HOME/.config/sublime-text-3/Installed Packages"
	sudo -u $SUDO_USER wget -O "$USER_HOME/.config/sublime-text-3/Installed Packages/Package Control.sublime-package" "https://sublime.wbond.net/Package%20Control.sublime-package"
else
	#No podemos correr sudo
	echo ''
fi

echo -e "\e[7m*** That's all. Have fun Sublime Texting ;)\e[0m"

exit 0
EOF


