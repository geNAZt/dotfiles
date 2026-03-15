#!/bin/bash

# 1. Define Paths
EXT_DIR="$HOME/Library/Application Support/Zed/extensions/installed"
SETTINGS_FILE="$HOME/.config/zed/settings.json"

if [ ! -d "$EXT_DIR" ]; then
    echo "❌ Zed extensions directory not found."
    exit 1
fi

echo "🔍 Scanning installed Zed extensions..."
EXTENSIONS=$(ls -1 "$EXT_DIR")

# 2. Use Python with a Comment-Stripping Regex
python3 << EOF
import json
import os
import re

def strip_comments(text):
    # Remove multi-line comments
    text = re.sub(r'/\*.*?\*/', '', text, flags=re.DOTALL)
    # Remove single-line comments
    text = re.sub(r'//.*', '', text)
    return text

settings_path = os.path.expanduser('$SETTINGS_FILE')
installed_exts = """$EXTENSIONS""".splitlines()

if os.path.exists(settings_path):
    with open(settings_path, 'r') as f:
        content = f.read()
        try:
            # Strip comments before parsing
            clean_content = strip_comments(content)
            data = json.loads(clean_content)
        except Exception as e:
            print(f"⚠️ Still failed to parse settings.json: {e}")
            # If it fails, we'll start with an empty dict to avoid data loss
            data = {}
else:
    data = {}

# Ensure the section exists
if 'auto_install_extensions' not in data:
    data['auto_install_extensions'] = {}

# Add new ones
added_count = 0
for ext in installed_exts:
    # Filter out hidden files or Zed system files if any
    if ext.startswith('.') or not ext:
        continue
    if ext not in data['auto_install_extensions']:
        data['auto_install_extensions'][ext] = True
        added_count += 1

# Write back
with open(settings_path, 'w') as f:
    # Note: Writing back will remove existing comments in settings.json
    # This is usually fine for a sync script used right before a wipe.
    json.dump(data, f, indent=2)

print(f"✅ Added {added_count} new extensions to auto_install_extensions.")
EOF

chezmoi add "$SETTINGS_FILE"
echo "✅ Updated settings.json and added to chezmoi."