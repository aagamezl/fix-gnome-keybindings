#!/bin/bash

#------------------------------------------------------------------------------#
# This script save the workspace switch keybindings and set a more appropiate  #
# keybindings that don´t collide with VS Code shortcuts.                       #
#                                                                              #
# Author: Álvaro José Agámez Licha                                             #
# Version: 1.0.0                                                               #
# Last Update: 2024-07-22                                                      #
#------------------------------------------------------------------------------#

app_home_name="$HOME/.window-config"
output_file="$app_home_name/org.gnome.desktop.wm.keybindings.backup"

if [ ! -d "$app_home_name" ]; then
  mkdir -p "$app_home_name"
fi

check_and_write() {
  local search_text="$1"
  local content_to_write="$2"
  local filename="$3"

  # Check if the search text exists in the file
  if ! grep -qF "$search_text" "$filename"; then
    echo "$content_to_write" >> "$filename"
  fi
}

get_keybindings() {
  local key_name="$1"

  result=$(gsettings get org.gnome.desktop.wm.keybindings $key_name)

  echo $result
}

set_keybindings() {
  local key_name="$1"
  local key_value="$2"

  gsettings set org.gnome.desktop.wm.keybindings "$key_name" "$key_value"
}

# Create the file if it doesn't exist
if [ ! -f "$output_file" ]; then
  touch "$output_file"
fi

# GENERATE KEYBINDINGS BACKUP
# Original: ['<Super>Page_Up', '<Super><Alt>Left', '<Control><Alt>Left']
keybindings=$(get_keybindings "switch-to-workspace-left")
check_and_write "switch-to-workspace-left" "switch-to-workspace-left=$keybindings" "$output_file"

# Original: ['<Super>Page_Down', '<Super><Alt>Right', '<Control><Alt>Right']
keybindings=$(get_keybindings "switch-to-workspace-right")
check_and_write "switch-to-workspace-right" "switch-to-workspace-right=$keybindings" "$output_file"

# Original: ['<Control><Alt>Up']
keybinding=$(get_keybindings "switch-to-workspace-up")
check_and_write "switch-to-workspace-up" "switch-to-workspace-up=$keybindings" "$output_file"

# Original: ['<Control><Alt>Down']
keybinding=$(get_keybindings "switch-to-workspace-down")
check_and_write "switch-to-workspace-down" "switch-to-workspace-down=$keybindings" "$output_file"

# SET NEW KEYBINDINGS
set_keybindings "switch-to-workspace-left" "['<Super>Page_Up', '<Super><Control>Left']"
set_keybindings "switch-to-workspace-right" "['<Super>Page_Up', '<Super><Control>Right']"
set_keybindings "switch-to-workspace-up" "['']"
set_keybindings "switch-to-workspace-down" "['']"
