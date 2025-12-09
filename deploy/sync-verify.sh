#!/bin/bash

# Card Wars Kingdom - Local to VPS Sync Verification Script
# Este script compara archivos entre local y VPS para verificar sincronización

set -e

echo "🔍 Card Wars Kingdom - Sync Verification Script"
echo "==============================================="

# Configuration
VPS_HOST="root@159.89.157.63"
PROJECT_PATH="/var/www/cardwars-kingdom.net"

# Files to check
FILES_TO_CHECK=(
    "app.py"
    "templates/creatures.html"
    "templates/index.html"
    "requirements.txt"
    "gunicorn_config.py"
    "wsgi.py"
)

echo "📋 Comparing files between local and VPS..."
echo ""

MISMATCH_COUNT=0
TOTAL_FILES=${#FILES_TO_CHECK[@]}

for file in "${FILES_TO_CHECK[@]}"; do
    echo "🔍 Checking: $file"
    
    # Check if file exists locally
    if [ ! -f "$file" ]; then
        echo "  ❌ File not found locally: $file"
        ((MISMATCH_COUNT++))
        continue
    fi
    
    # Check if file exists on VPS
    VPS_EXISTS=$(ssh $VPS_HOST "[ -f '$PROJECT_PATH/$file' ] && echo 'exists' || echo 'missing'")
    if [ "$VPS_EXISTS" = "missing" ]; then
        echo "  ❌ File not found on VPS: $file"
        ((MISMATCH_COUNT++))
        continue
    fi
    
    # Compare checksums
    LOCAL_MD5=$(md5sum "$file" | cut -d' ' -f1)
    VPS_MD5=$(ssh $VPS_HOST "cd $PROJECT_PATH && md5sum '$file' | cut -d' ' -f1")
    
    if [ "$LOCAL_MD5" = "$VPS_MD5" ]; then
        echo "  ✅ Match - $LOCAL_MD5"
    else
        echo "  ❌ Mismatch!"
        echo "    Local:  $LOCAL_MD5"
        echo "    VPS:    $VPS_MD5"
        ((MISMATCH_COUNT++))
    fi
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Verification Results:"
echo "  • Total files checked: $TOTAL_FILES"
echo "  • Files matching: $((TOTAL_FILES - MISMATCH_COUNT))"
echo "  • Files mismatched: $MISMATCH_COUNT"

if [ $MISMATCH_COUNT -eq 0 ]; then
    echo "  🎉 All files are perfectly synchronized!"
else
    echo "  ⚠️  $MISMATCH_COUNT file(s) need synchronization"
fi

echo ""
echo "🔧 Additional Checks:"

# Check service status
SERVICE_STATUS=$(ssh $VPS_HOST "systemctl is-active cardwars-kingdom-net.service")
echo "  • Service Status: $SERVICE_STATUS"

# Check website response
HTTP_STATUS=$(ssh $VPS_HOST "curl -s -o /dev/null -w '%{http_code}' https://cardwars-kingdom.net/" || echo "ERROR")
echo "  • Website Status: HTTP $HTTP_STATUS"

# Check git status
GIT_STATUS=$(ssh $VPS_HOST "cd $PROJECT_PATH && git status --porcelain | wc -l")
if [ "$GIT_STATUS" = "0" ]; then
    echo "  • Git Status: Clean (no uncommitted changes)"
else
    echo "  • Git Status: $GIT_STATUS uncommitted changes"
fi

# Show current commit
LOCAL_COMMIT=$(git rev-parse --short HEAD)
VPS_COMMIT=$(ssh $VPS_HOST "cd $PROJECT_PATH && git rev-parse --short HEAD")
echo "  • Local Commit: $LOCAL_COMMIT"
echo "  • VPS Commit: $VPS_COMMIT"

if [ "$LOCAL_COMMIT" = "$VPS_COMMIT" ]; then
    echo "  ✅ Commits match"
else
    echo "  ❌ Commits differ"
    ((MISMATCH_COUNT++))
fi

echo ""

if [ $MISMATCH_COUNT -eq 0 ]; then
    echo "✅ Perfect synchronization! Local and VPS are identical."
    exit 0
else
    echo "⚠️  Synchronization issues found. Run one of these commands to fix:"
    echo ""
    echo "   # Option 1: Clean deployment (recommended)"
    echo "   ./deploy/clean-deploy.sh"
    echo ""
    echo "   # Option 2: Copy specific files"
    echo "   scp app.py templates/creatures.html requirements.txt $VPS_HOST:$PROJECT_PATH/"
    echo "   ssh $VPS_HOST 'chown -R www-data:www-data $PROJECT_PATH && systemctl restart cardwars-kingdom-net.service'"
    echo ""
    exit 1
fi