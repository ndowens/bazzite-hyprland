#!/bin/bash

RELEASE="$(rpm -E %fedora)"
set -ouex pipefail

enable_copr() {
    repo="$1"
    repo_with_dash="${repo/\//-}"
    wget "https://copr.fedorainfracloud.org/coprs/${repo}/repo/fedora-${RELEASE}/${repo_with_dash}-fedora-${RELEASE}.repo" \
        -O "/etc/yum.repos.d/_copr_${repo_with_dash}.repo"
}
#
### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Use a COPR Example:
# if using helper function above:
# enable_copr solopasha/hyprland
# dnf5 -y copr enable ublue-os/staging
dnf5 copr enable solopasha/hyprland
dnf5 copr enable erikreider/SwayNotificationCenter
dnf5 copr enable pgdev/ghostty

enable_copr wezfurlong/wezterm-nightly

dnf5 install -y --setopt=install_weak_deps=False \
    xdg-desktop-portal-hyprland \
    hyprland \
    swayidle \
    waybar \
    wofi \
    swaync \
    wl-clipboard \
    grim \
    brightnessctl \
    pavucontrol \
    network-manager-applet \
    clipman \
    nwg-drawer \
    wdisplays \
    pavucontrol \
    SwayNotificationCenter \
    NetworkManager-tui \
    tmux \
    wezterm \
    ghostty

# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable solopasha/hyprland
# dnf5 -y copr disable erikreider/SwayNotificationCenter

#### Example for enabling a System Unit File

# systemctl enable podman.socket
mkdir -p /nix/var/nix/gcroots/per-user/bazzite
