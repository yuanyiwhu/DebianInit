#! /bin/bash
# Configure sources
sudo apt-get update

# Configure development environment
sudo apt-get install -y -q vim zsh git wget dos2unix python python-setuptools
# shell environment...
wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
pushd ~
git clone https://github.com/rupa/z
popd
sudo easy_install trash-cli
# .zshrc
git clone https://gist.github.com/8777085.git
mv 8777085/.zshrc ~
rm -rf 8777085
# vim configuration
git clone https://gist.github.com/4576917.git
cat 4576917/vimrc | sed 's/consolas:h16/Inconsolata\\ 14/' > ~/.vimrc
rm -rf 4576917
mkdir ~/.vim
pushd ~/.vim
mkdir colors
pushd colors
wget http://files.werx.dk/wombat.vim
dos2unix wombat.vim
popd
wget "http://www.vim.org/scripts/download_script.php\?src_id\=17123" -O nerdtree.zip
unzip nerdtree.zip
rm nerdtree.zip
wget "http://downloads.sourceforge.net/project/vim-latex/snapshots/vim-latex-1.8.23-20130116.788-git2ef9956.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fvim-latex%2Ffiles%2Fsnapshots%2F&ts=1384542687&use_mirror=softlayer-dal" -O latex.tar.gz
tar -xzvf latex.tar.gz
mv vim-latex*/* .
rm -r vim-latex*
rm latex.tar.gz
popd
# git configuration
git config --global user.name "Yan Wang"
git config --global user.email grapeot@gmail.com
git config --global push.default simple # eliminate the warning message of the new version git
# ssh configuration (won't take effect until restart)
sudo bash -c "cat /etc/ssh/sshd_config | sed 's/Port 22/Port 30/' | tee /etc/ssh/sshd_config"
# Other tweaks
cp .tmux.conf ~

# Installing desktop environment 
sudo apt-get install -y -q tig build-essential curl htop rsync tmux python zip unzip python-gtk2 python-wnck python-xlib xfce4 xfce4-power-manager xfce4-screenshooter xfce4-terminal xfce4-systemload-plugin vim-gtk evince pulseaudio cups cups-client ristretto ttf-wqy-microhei ttf-wqy-zenhei fonts-inconsolata gnome-screensaver xauth x11-apps openjdk-6-jre tightvncserver
# Make the X11 work properly
cat /etc/X11/Xwrapper.config | sed 's/console/anybody/' | sudo cat >> /etc/X11/Xwrapper.config
sudo chown ubuntu:ubuntu ~/.Xauthority
# Configure the fonts and themes
sudo apt-get remove -y xscreensaver
wget http://font.ubuntu.com/download/ubuntu-font-family-0.80.zip
unzip ubuntu-font-family-0.80.zip
mkdir ~/.fonts
mv ubuntu-font-family-0.80/*.ttf ~/.fonts
rm -rf ubuntu-font-family-0.80
rm ubuntu-font-family-0.80.zip
fc-cache -fv
mkdir ~/.themes
pushd ~/.themes
wget http://gnome-look.org/CONTENT/content-files/150905-adwaita-x-dark-light-1.3.zip -O Adwaita.zip 
unzip Adwaita.zip
rm Adwaita.zip
ln -s /usr/share/themes/Adwaita/gtk-3.0 ~/.themes/Adwaita-X-dark/gtk-3.0
popd

# Optional software, uncomment to install
# quicktile
wget http://github.com/ssokolow/quicktile/zipball/master -O quicktile.zip
unzip quicktile.zip
cd ssokolow-quicktile*
sudo ./setup.py install
cd ..
mkdir ~/.config
cp quicktile.cfg ~/.config
sudo rm -rf ssokolow-quicktile*
rm quicktile.zip
# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
# Dropbox
wget https://www.dropbox.com/download?dl=packages/debian/dropbox_1.6.0_amd64.deb -O dropbox.deb
sudo dpkg -i dropbox.deb
sudo apt-get install -f -y
rm google-chrome-stable_current_amd64.deb dropbox.deb
# Change the default shell in the end because it requires user interactions
echo If this is an EC2 instance, change your password first so we can change the default shell:
sudo passwd ubuntu
chsh -s $(which zsh)
# Launch the vnc server
vncserver :1
