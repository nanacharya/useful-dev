#!/bin/bash

echo "⚡ Starting safe Mac cleanup..."

# Disk used before
USED_BEFORE=$(df / | tail -1 | awk '{print $3}')
HUMAN_BEFORE=$(df -h / | tail -1 | awk '{print $3}')

echo "🚀 Disk used BEFORE cleanup: $HUMAN_BEFORE"

# 1. Clear user caches
echo "Clearing user Library caches..."
rm -rf ~/Library/Caches/* 2>/dev/null

# 2. Clear system logs
echo "Clearing system logs..."
sudo rm -rf /private/var/log/*

# 3. Purge inactive memory
echo "Purging inactive memory..."
sudo purge

# 4. Remove old iOS backups
echo "Removing old iOS backups..."
rm -rf ~/Library/Application\ Support/MobileSync/Backup/*

# 5. Clean Homebrew cache, capturing freed size
HOMEBREW_FREED=0
if command -v brew >/dev/null 2>&1; then
    echo "Cleaning Homebrew cache..."
    BREW_OUTPUT=$(brew cleanup 2>&1)
    echo "$BREW_OUTPUT"

    # Parse Homebrew freed space
    HOMEBREW_FREED=$(echo "$BREW_OUTPUT" | grep 'freed approximately' | grep -Eo '[0-9\.]+MB' | grep -Eo '[0-9\.]+')
fi

# 6. Clean unused Xcode simulators
if command -v xcrun >/dev/null 2>&1; then
    echo "Cleaning unused Xcode simulators..."
    xcrun simctl delete unavailable
fi

# 7. Check disk
echo "Verifying disk volume..."
diskutil verifyVolume /

# Disk used after
USED_AFTER=$(df / | tail -1 | awk '{print $3}')
HUMAN_AFTER=$(df -h / | tail -1 | awk '{print $3}')

echo "✅ Disk used AFTER cleanup: $HUMAN_AFTER"

# Calculate difference
SAVED_KB=$((USED_BEFORE - USED_AFTER))
SAVED_MB=$(echo "scale=2; $SAVED_KB/1024" | bc)
SAVED_GB=$(echo "scale=2; $SAVED_KB/1024/1024" | bc)

# Add any Homebrew freed amount if it existed
if [[ $HOMEBREW_FREED != "" ]]; then
    SAVED_MB=$(echo "scale=2; $SAVED_MB + $HOMEBREW_FREED" | bc)
fi

# Show cleanup summary
echo "🎉 Cleanup saved approximately:"
echo "   - ${SAVED_MB} MB total (includes Homebrew)"
echo "   - ${SAVED_GB} GB"

echo "✨ Done! Recommend a restart."

#  Find giant files in your user folder
# find ~ -type f -size +500M -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'