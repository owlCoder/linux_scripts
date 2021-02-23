#################################################################################################################
###                                                                                                           ###
###                       ARCH LINUX INSTALLATION PROCCESS  GPL v3                                            ###
###                       CUSTOM SCRIPT MADE BY: owlCoder                                                     ###
###                                                                                                           ###
###                       #include <std_disclaimer.h>                                                         ###
###                                                                                                           ###
###                       Your warranty is now void.                                                          ###
###                                                                                                           ###
###                       I am not responsible for bricked devices, dead SD cards,                            ###
###                       thermonuclear war, or you getting fired because the alarm app failed. Please        ###
###                       do some research if you have any concerns about features included in this ROM       ###
###                       before flashing it! YOU are choosing to make these modifications, and if            ###
###                       you point the finger at me for messing up your device, I will laugh at you.         ###
###                                                                                                           ###
###                                                                                                           ###
#################################################################################################################


# PREPARATION
fdisk -l
fdisk /dev/sda

# YOU NNED TO CREATE NEW PARTITIONS SO TAKE A LOOK INTO 'fdisk n' COMMANDS!

# FORMAT DISK (WHOLE DISK WIPE)
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# CONNECT TO WIFI (IF NO ETHERNET PRESENT)
wifi-menu

# INSTALL ARCH
mount /dev/sda2 /mnt
pacstrap /mnt base linux linux-firmware nano

# GENERATE FSTAB
genfstab -U /mnt >> /mnt/etc/fstab

# TIME ZONE
arch-chroot /mnt
timedatectl list-timezones
timedatectl set-timezone Europe/Belgrade

# REGION SETTINGS
locale-gen
echo LANG=en_GB.UTF-8 > /etc/locale.conf
export LANG=en_GB.UTF-8


# SET UP HOSTANAME AND LOCALE
echo leopard > /etc/hostname

touch /etc/hosts
# hosts file
127.0.0.1	localhost
::1		    localhost
127.0.0.1	leopard

# EFI
pacman -S grub efibootmgr
mkdir /boot/efi
mount /dev/sda1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

# LEGACY
pacman -S grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# DE INSTALL
pacman -S xorg
pacman -S gnome

systemctl start gdm.service
systemctl enable gdm.service
systemctl enable NetworkManager.service

# FINISH
exit && shutdown now
