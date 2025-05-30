#!/bin/bash

#------------------------------------------------------------------------------#
# This script restores the workspace switch keybindings that were modified by  #
# the original script. It uses the backup file if available, otherwise uses    #
# the default keybindings that were replaced.                                  #
#                                                                              #
# Author: Reverse script of aagamezl's fix-gnome-keybindings                   #
# Version: 1.0.0                                                               #
# Last Update: 2023-10-30                                                      #
#------------------------------------------------------------------------------#

app_home_name="$HOME/.window-config"
backup_file="$app_home_name/org.gnome.desktop.wm.keybindings.backup"

# Default keybindings that the original script replaced
DEFAULT_LEFT="['<Super>Page_Up', '<Super><Alt>Left', '<Control><Alt>Left']"
DEFAULT_RIGHT="['<Super>Page_Down', '<Super><Alt>Right', '<Control><Alt>Right']"
DEFAULT_UP="['<Control><Alt>Up']"
DEFAULT_DOWN="['<Control><Alt>Down']"

set_keybindings() {
  local key_name="$1"
  local key_value="$2"

  gsettings set org.gnome.desktop.wm.keybindings "$key_name" "$key_value"
}

restore_from_backup() {
  local key_name="$1"
  
  if [ -f "$backup_file" ]; then
    # Extract the keybinding from backup file
    local line=$(grep "^$key_name=" "$backup_file")
    if [ -n "$line" ]; then
      # Remove the keyname and = from the beginning
      local key_value="${line#*=}"
      set_keybindings "$key_name" "$key_value"
      return 0
    fi
  fi
  return 1
}

# Restore or set default keybindings
if ! restore_from_backup "switch-to-workspace-left"; then
  set_keybindings "switch-to-workspace-left" "$DEFAULT_LEFT"
fi

if ! restore_from_backup "switch-to-workspace-right"; then
  set_keybindings "switch-to-workspace-right" "$DEFAULT_RIGHT"
fi

if ! restore_from_backup "switch-to-workspace-up"; then
  set_keybindings "switch-to-workspace-up" "$DEFAULT_UP"
fi

if ! restore_from_backup "switch-to-workspace-down"; then
  set_keybindings "switch-to-workspace-down" "$DEFAULT_DOWN"
fi

echo "GNOME workspace keybindings have been restored."
