# Pre install
make partition on windows
disable secure boot (bios)
disable fast startup (ctrl panel -> power options -> faststartup)
disable hibernation (powercfg.exe /hibernate off)
download arch iso from mirror
boot into live environment

# Install

### Networking
```
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect test
```
or
`iwctl --passphrase NETWORK-PASSWORD station DEVICE-NAME connect NETWORK-NAME`

### Clock
`timedatectl set-ntp true`

### Disk setup
`lsblk`
v:=disk
`cfdisk /dev/v`
make swap, root partition

efi:=/dev/efi_partition
root:=/dev/root_partition
swap:=/dev/swap_partition

```
mkfs.ext4 root
mkswap swap
swapon swap
mount root /mnt 
mount --mkdir efi /mnt/efi
```

### Install system
```
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

### System configuration
```
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc
```

`pacman -Sy neovim`

Edit /etc/locale.gen and uncomment en_US.UTF-8 UTF-8.
```
locale-gen
vim /etc/locale.conf
```

Edit /etc/hostname, and write name of machine on network

Edit /etc/hosts to look like this
```
127.0.0.1	localhost
::1		localhost
127.0.1.1	koawa.localdomain	koawa
```

### User configuration
Create user, set user passwd, set root passwd
```
useradd -G wheel,audio,video -m USERNAME
passwd USERNAME
passwd
```

### Grub
```
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/efi/ --bootloader-id=GRUB
```

Edit /etc/default/grub and uncomment `GRUB_DISABLE_OS_PROBER=false`
`grub-mkconfig -o /boot/grub/grub.cfg`


# Post Install

### Sudo
```
pacman -S sudo
ln -s /usr/bin/nvim /usr/bin/vi
```

Add these two lines in sudoers file
```
root ALL=(ALL:ALL) ALL
neil ALL=(ALL:ALL) ALL
```

Edit the faillock config to disable lockout *just personal preference on my desktop, probably not advisable* 
`nvim /etc/security/faillock.conf` and set `deny = 0`

### Networking
```
pacman -S networkmanager network-manager-applet networkmanager-dmenu-git wpa_supplicant
systemctl enable NetworkManager.service
```

Reboot

```
nmcli d 
nmcli r wifi on 
nmcli d wifi list 
nmcli d wifi connect WIFI_SSID_HERE password --YOUR_PASSWORD_HERE
```

### yay
`pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si`

### zsh
```
pacman -S zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install necessary packages
```
yay -S --needed - < ./packages/xorg
yay -S --needed - < ./packages/required
yay -S --needed - < ./packages/audio
yay -S --needed - < ./packages/fonts
```

### Enable TRIM for SSD's
`systemctl enable fstrim.timer`

### Configure pacman
Refer to `/etc/pacman.conf`
To enable parallel downloads, uncomment the `#ParallelDownloads = 5` line
To enable multilib, uncomment
```
[multilib]
Include = /etc/pacman.d/mirrorlist
```


### Configure zsh

zsh-autosuggestions
`git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`

Add `zsh-autosuggestions` to plugins list in ~/.zshrc (already done if following dots)

zsh-syntax-highlighting
`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting`

Add `zsh-syntax-highlighting` to the end of plugins list (already done if following dots)

Set ZSH to be the default shell
`chsh -s $(which zsh)`

### Autologin
Create a file with the following contests at `/etc/systemd/system/getty@tty1.service.d/autologin.conf`
```
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin neil - $TERM
```

Automatic X11 start should be configured with dotfiles
