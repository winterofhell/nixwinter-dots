set -l flake /etc/nixos
set -l target (string join "" $flake "#nixos")
set -l old_system (readlink -f /run/current-system)
set -l lock_backup (mktemp)

cp "$flake/flake.lock" "$lock_backup"
or begin
  rm -f "$lock_backup"
  return 1
end

sudo nix flake update --refresh --flake "$flake"
or begin
  sudo cp "$lock_backup" "$flake/flake.lock"
  rm -f "$lock_backup"
  return 1
end

sudo nixos-rebuild switch --flake "$target" --accept-flake-config
set -l rebuild_status $status

if test $rebuild_status -ne 0
  sudo cp "$lock_backup" "$flake/flake.lock"
  rm -f "$lock_backup"
  echo "Build failed; flake.lock restored."
  return $rebuild_status
end

rm -f "$lock_backup"
nvd diff "$old_system" /run/current-system
git -C "$flake" status --short
