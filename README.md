# nixwinter-dots

NixOS unstable configuration for Ryzen 7 9850X3D, Radeon RX 9070 XT, KDE Plasma, Home Manager, Fish, Kitty and gaming.

## Rebuild

```sh
sudo nixos-rebuild dry-build --flake /etc/nixos#nixos --accept-flake-config
sudo nixos-rebuild switch --flake /etc/nixos#nixos --accept-flake-config
```

## Verify

```sh
uname -r
scxctl get
gamemoded -t
zramctl
systemctl --failed
systemctl --user --failed
mini-eq --check-deps
```
