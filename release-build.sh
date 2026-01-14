#!/bin/bash

# ESP32 Build Release Script
# Builds project and creates GitHub release with binaries

set -e  # Exit on error

# Configuration
PROJECT_DIR="$(pwd)"
BUILD_DIR="$PROJECT_DIR/build"
VERSION="v$(date +%Y%m%d-%H%M%S)"

echo "🔨 Building project..."
get_idf
idf.py build

echo "📦 Creating release $VERSION..."

# Check if binaries exist
#if [ ! -f "$BUILD_DIR/firmware.bin" ]; then
#    echo "❌ Build failed - firmware.bin not found"
#    exit 1
#fi

# Create release with all binary files
gh release create "$VERSION" \
    "$BUILD_DIR"/*.bin \
    --title "Build $VERSION" \
    --notes "Automated build from commit $(git rev-parse --short HEAD)" \
    --repo "$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')"

echo "✅ Release created: $VERSION"
echo "📥 Download with: gh release download $VERSION"
