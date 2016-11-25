#check if any systemd services have entered in a failed state
sudo systemctl --failed

# Look for high priority errors in the systemd journal
sudo journalctl -p 0..3 -xn

# Refresh all package lists even if they are considered to be up to date
# and updates the system
sudo pacman -Syyu

# Search for orphaned packages and if found, removes them recursively
if [[ ! -n $(pacman -Qdt) ]]; then
  echo "No orphans to remove."
else
  sudo pacman -Rns $(pacman -Qdtq)
fi

# Removes all the cached packages that are not currently installed
sudo pacman -Sc

# Optimize pacman database of installed packages
sudo pacman-optimize
