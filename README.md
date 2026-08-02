# nixwinter-dots

NixOS unstable conf

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
