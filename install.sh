#/bin/sh

cd
yay -S --noconfirm --needed - < ./packages/xorg
yay -S --noconfirm --needed - < ./packages/required
yay -S --noconfirm --needed - < ./packages/tools
yay -S --noconfirm --needed - < ./packages/audio
yay -S --noconfirm --needed - < ./packages/fonts
yay -S --noconfirm --needed - < ./packages/laptop
yay -S --noconfirm --needed - < ./packages/apps


rm ~/.zshrc
mkdir ~/scripts
mkdir ~/.config/mpv
mkdir ~/.config/mpd
mkdir ~/.config/ncmpcpp
mkdir ~/.config/gtk-4.0

git clone https://github.com/asiankoala/dotfiles ~/dotfiles
cd ~/dotfiles
bombadil install
bombadil link -p laptop
cd

cp -r ~/archsetup/packages/polybar-fonts ~/.local/share/fonts/

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/subnixr/minimal.git  ${ZSH_CUSTOM}/themes/minimal\nln -s ${ZSH_CUSTOM}/themes/minimal/minimal.zsh ${ZSH_CUSTOM}/themes/minimal.zsh-theme

chsh -s $(which zsh)

systemctl enable fstrim.timer

sudo mkdir /etc/systemd/system/getty@tty1.service.d
sudo cp ~/archsetup/autologin.conf /etc/systemd/system/getty@tty1.service.d/autologin.conf
sudo cp ~/dotfiles/x11/device/* /etc/X11/xorg.conf.d

ssh-keygen -t ed25519 -C "neilmehra@outlook.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

while true; do
  read -p "Add ssh key to GitHub, then type 'yes' to continue" input
  if [ "$input" = "yes" ]; then
    break
  fi
  sleep 1 
done

echo "Continuing..."

cd ~/dotfiles
git submodule update --init --recursive
cd

mkdir ~/.themes
mkdir ~/.icons
cp ~/dotfiles/gtk/themes/gtk3.tar.gz ~/.themes
cp ~/dotfiles/gtk/themes/rose-pine-icons.tar.gz ~/.icons
cd ~/.themes
tar -xf ~/.themes/gtk3.tar.gz

# todo 

cd ~/.icons
tar -xf ~/.icons/rose-pine-icons.tar.gz


# todo

sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
