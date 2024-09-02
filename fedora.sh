#!/bin/bash

# Set timezone to Europe/Berlin
sudo timedatectl set-timezone Europe/Berlin
echo "Timezone set to Europe/Berlin"

# Update the system
sudo dnf update -y
echo "System updated"

# Check for NVIDIA GPU
if lspci | grep -i nvidia > /dev/null; then
    echo "NVIDIA GPU detected. Proceeding with package installation."
    
    sudo dnf install -y kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
else
    echo "No NVIDIA GPU detected. Skipping package installation."
fi

# Install packages
sudo dnf install -y \
    git \
    htop \
    btop \
    zsh \
    tmux \
    unzip \
    curl \
    wget \
    make \
    vim \
    bat \
    google-chrome-stable \
    tldr \
    thefuck \
    cabextract \
    xorg-x11-font-utils \
    fontconfig \
    neovim \
    alacritty \
    yaru-icon-theme \
    golang \
    powerline-fonts \
    fzf \
    eza \
    jq \
    keepassxc \
    net-tools \
    p7zip \
    unrar \
    nmap \
    netcat \
    fastfetch \
    python3-pip \
    sipcalc \
    bind-utils \
    xz \
    zoxide \
    snapper \
    ripgrep \
    inotify-tools \
    python3-dnf-plugin-snapper \
    kitty \
    ansible \
    gnome-tweaks \
    gnome-shell-extension-pop-shell \
    xprop \
    stow \
    btrfs-assistant \
    helm \
    kubernetes-client
echo "Packages installed"

echo "Script completed successfully!"

# setup btrfs
sudo snapper -c root create-config /
sudo snapper -c home create-config /home
sudo snapper -c root set-config ALLOW_USERS=$USER SYNC_ACL=yes
sudo snapper -c home set-config ALLOW_USERS=$USER SYNC_ACL=yes
sudo chown -R :$USER /.snapshots
sudo chown -R :$USER /home/.snapshots

# Install VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install -y code

# Install Lens
sudo dnf config-manager --add-repo https://downloads.k8slens.dev/rpm/lens.repo
sudo dnf install -y lens

# Install Fonts
cd
mkdir git
mkdir git/priv
cd git/priv
git clone https://github.com/anba94/fonts.git
cd fonts
sudo cp *.ttf /usr/share/fonts
sudo fc-cache -f -v

sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

# Wallpaper
curl -s https://wallpapers.manishk.dev/install.sh | bash -s Firewatch
curl -s https://wallpapers.manishk.dev/install.sh | bash -s A_Certain_Magical_Index
curl -s https://wallpapers.manishk.dev/install.sh | bash -s Lakeside-2
curl -s https://wallpapers.manishk.dev/install.sh | bash -s Catalina

# Candy-Icons
cd
mkdir -p ~/.local/share/icons
wget https://github.com/EliverLara/candy-icons/archive/refs/heads/master.zip -O candy-icons.zip
unzip candy-icons.zip
mv candy-icons-master ~/.local/share/icons/candy-icons
rm candy-icons.zip

# Cursor
sudo dnf copr enable peterwu/rendezvous -y
sudo dnf install bibata-cursor-themes -y

# Gnome Settings
#gsettings set org.gnome.desktop.interface icon-theme yaru-magenta-dark
gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy'
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
gsettings set org.gnome.desktop.interface cursor-size 32

# Zellij
sudo dnf copr enable varlad/zellij -y
sudo dnf install -y zellij

# Go Apps
go install github.com/jesseduffield/lazygit@latest
#go install sigs.k8s.io/kind@v0.23.0
#go install github.com/derailed/k9s@latest
go install github.com/Gelio/go-global-update@latest

# Starship
curl -sS https://starship.rs/install.sh | sh

# pokemon-colorscript
mkdir git/other
cd git/other
git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git
cd pokemon-colorscripts
sudo ./install.sh

# ZSH
cd
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

#dotfiles
cd
rm .bashrc
rm .zshrc
git clone https://github.com/anba94/dotfiles.git
mv dotfiles .dotfiles
cd .dotfiles
stow .

# Neovim
#git clone https://github.com/NvChad/starter ~/.config/nvim && nvim

# Install flatpaks
flatpak install -y flathub md.obsidian.Obsidian
flatpak install -y flathub io.github.zen_browser.zen
flatpak install -y flathub org.gnome.World.PikaBackup
flatpak install -y flathub com.mattjakeman.ExtensionManager
flatpak install -y flathub com.obsproject.Studio
flatpak install -y flathub org.onlyoffice.desktopeditors
flatpak install -y flathub com.bitwarden.desktop
flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub io.podman_desktop.PodmanDesktop
flatpak install -y flathub io.github.flattool.Warehouse

# change default shell
chsh -s $(which zsh)