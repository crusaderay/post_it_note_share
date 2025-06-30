#!/bin/bash

# Memo Sticky GitHub Pages Deployment Script
# This script helps you deploy the Universal Link files to GitHub Pages

echo "🚀 Memo Sticky GitHub Pages Deployment"
echo "======================================"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

# Get GitHub username
read -p "Enter your GitHub username: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo "❌ GitHub username is required."
    exit 1
fi

REPO_NAME="$GITHUB_USERNAME.github.io"
REPO_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"

echo "📁 Repository: $REPO_NAME"
echo "🔗 URL: $REPO_URL"
echo ""

# Ask if repository exists
read -p "Does the repository '$REPO_NAME' already exist on GitHub? (y/n): " REPO_EXISTS

if [[ $REPO_EXISTS != "y" && $REPO_EXISTS != "Y" ]]; then
    echo "❌ Please create the repository '$REPO_NAME' on GitHub first."
    echo "   1. Go to https://github.com/new"
    echo "   2. Repository name: $REPO_NAME"
    echo "   3. Make it public"
    echo "   4. Don't initialize with README"
    echo "   5. Click 'Create repository'"
    exit 1
fi

# Create temporary directory
TEMP_DIR="/tmp/memo-sticky-pages"
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "📥 Cloning repository..."
git clone "$REPO_URL" .

if [ $? -ne 0 ]; then
    echo "❌ Failed to clone repository. Please check:"
    echo "   - Repository exists and is public"
    echo "   - You have access to the repository"
    echo "   - Your Git credentials are set up"
    exit 1
fi

echo "📋 Copying files..."

# Copy files from the github-pages directory
SOURCE_DIR="$(dirname "$0")"
cp "$SOURCE_DIR/index.html" .
cp "$SOURCE_DIR/apple-app-site-association" .
mkdir -p .well-known
cp "$SOURCE_DIR/.well-known/apple-app-site-association" .well-known/
mkdir -p u/entry
cp "$SOURCE_DIR/u/entry/index.html" u/entry/

# Update files with correct GitHub username
echo "🔧 Updating configuration..."
sed -i.bak "s/dongjiezhang/$GITHUB_USERNAME/g" index.html
sed -i.bak "s/dongjiezhang/$GITHUB_USERNAME/g" u/entry/index.html
rm -f *.bak u/entry/*.bak

echo "📝 Committing changes..."
git add .
git commit -m "Add Universal Link support for Memo Sticky app"

echo "🚀 Pushing to GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ Deployment successful!"
    echo ""
    echo "🌐 Your GitHub Pages site will be available at:"
    echo "   https://$GITHUB_USERNAME.github.io"
    echo ""
    echo "🔗 Universal Link test URL:"
    echo "   https://$GITHUB_USERNAME.github.io/u/entry?text=Hello%20World"
    echo ""
    echo "⏰ Note: It may take a few minutes for GitHub Pages to deploy."
    echo "📱 Test the Universal Link after building and installing your app."
else
    echo "❌ Failed to push to GitHub. Please check your Git credentials."
    exit 1
fi

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo "🧹 Cleanup completed."
echo "✨ All done! Your Universal Link setup is ready."