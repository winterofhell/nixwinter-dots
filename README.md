# nixwinter-dots

NixOS unstable gaming configuration for amd cpu and amd gpu

## Install

```bash
sudo install -m 0644 configuration.nix flake.nix flake.lock kitty.conf mini-eq.nix /etc/nixos/
sudo nixos-rebuild dry-build --flake /etc/nixos#nixos --accept-flake-config
sudo nixos-rebuild boot --flake /etc/nixos#nixos --accept-flake-config
sudo reboot
```

## Verify

```bash
uname -r
scxctl get
gamemoded -t
zramctl
systemctl --failed
mini-eq --check-deps
```
