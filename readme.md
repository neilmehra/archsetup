pre install
-----------
make partition on windows
disable secure boot (bios)
disable fast startup (ctrl panel -> power options -> faststartup)
disable hibernation (powercfg.exe /hibernate off)
download arch iso from mirror
boot into live environment

networking
----------
```
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect test
```
or
`iwctl --passphrase NETWORK-PASSWORD station DEVICE-NAME connect NETWORK-NAME`

clock
-----
`timedatectl set-ntp true`

disk setup
------------
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

Install system
```
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

System clock
````
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

User stuff
Create user, set user passwd, set root passwd
```
useradd -G wheel,audio,video -m USERNAME
passwd USERNAME
passwd
```

Grub stuff
```
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/efi/ --bootloader-id=GRUB
```

Edit /etc/default/grub and uncomment `GRUB_DISABLE_OS_PROBER=false`
`grub-mkconfig -o /boot/grub/grub.cfg`



## Post Install
Networking
`pacman -S networkmanager network-manager-applet networkmanager-dmenu-git wpa_supplicant`

Reboot

```
nmcli d 
nmcli r wifi on 
nmcli d wifi list 
nmcli d wifi connect WIFI_SSID_HERE password --YOUR_PASSWORD_HERE
```

yay
`pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si`

zsh
```
pacman -S zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```


