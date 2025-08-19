#!/bin/bash

set -e  # Exit on any error

# Function to show usage
show_usage() {
    echo "Usage: $0 [BASE_BRANCH]"
    echo ""
    echo "Squash all commits from current branch into a single commit using Claude CLI"
    echo ""
    echo "Arguments:"
    echo "  BASE_BRANCH    The base branch to compare against (default: release)"
    echo ""
    echo "Examples:"
    echo "  $0                    # Compare against 'release' branch"
    echo "  $0 main              # Compare against 'main' branch"
    echo "  $0 develop           # Compare against 'develop' branch"
    echo ""
    echo "The script will:"
    echo "  1. Create a backup branch"
    echo "  2. Use Claude CLI to generate a professional commit message"
    echo "  3. Squash all commits into a single commit"
    echo "  4. Show next steps for pushing and creating PR"
}

# Parse command line arguments
BASE_BRANCH="release"
if [ $# -eq 1 ]; then
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_usage
        exit 0
    fi
    BASE_BRANCH="$1"
elif [ $# -gt 1 ]; then
    echo "❌ Error: Too many arguments"
    show_usage
    exit 1
fi

echo "🔍 Checking git status..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Check if claude CLI is available
if ! command -v claude &> /dev/null; then
    echo "❌ Error: Claude CLI not found. Please install it first."
    echo "Visit: https://docs.anthropic.com/en/docs/claude-code/quickstart"
    exit 1
fi

# Get current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "📍 Current branch: $CURRENT_BRANCH"
echo "📍 Base branch: $BASE_BRANCH"

# Check if base branch exists
if ! git show-ref --verify --quiet refs/heads/$BASE_BRANCH && ! git show-ref --verify --quiet refs/remotes/origin/$BASE_BRANCH; then
    echo "❌ Error: '$BASE_BRANCH' branch not found locally or remotely"
    echo "Available local branches:"
    git branch --list
    echo ""
    echo "Available remote branches:"
    git branch -r 2>/dev/null || echo "No remote branches found"
    exit 1
fi

# Fetch latest base branch
echo "🔄 Fetching latest $BASE_BRANCH branch..."
git fetch origin $BASE_BRANCH:$BASE_BRANCH 2>/dev/null || git fetch origin $BASE_BRANCH 2>/dev/null || echo "⚠️  Could not fetch $BASE_BRANCH branch, using local version"

# Count commits ahead of base branch
COMMIT_COUNT=$(git rev-list --count $BASE_BRANCH..HEAD)
echo "📊 Commits ahead of $BASE_BRANCH: $COMMIT_COUNT"

if [ "$COMMIT_COUNT" -eq 0 ]; then
    echo "✅ No commits to squash - branch is up to date with $BASE_BRANCH"
    exit 0
fi

if [ "$COMMIT_COUNT" -eq 1 ]; then
    echo "✅ Only one commit ahead - no squashing needed"
    exit 0
fi

# Show commits that will be squashed
echo "📝 Commits to be squashed:"
git log --oneline $BASE_BRANCH..HEAD

# Check for uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "❌ Error: You have uncommitted changes. Please commit or stash them first."
    git status --porcelain
    exit 1
fi

# Create backup branch
BACKUP_BRANCH="${CURRENT_BRANCH}-backup-$(date +%Y%m%d-%H%M%S)"
echo "💾 Creating backup branch: $BACKUP_BRANCH"
git branch "$BACKUP_BRANCH"

# Collect detailed commit information
echo "📋 Collecting commit details..."
COMMIT_DETAILS=$(git log --format="Commit %h: %s%n%b%n---" $BASE_BRANCH..HEAD)
FILE_CHANGES=$(git diff --name-status $BASE_BRANCH..HEAD)
DIFF_SUMMARY=$(git diff --stat $BASE_BRANCH..HEAD)

# Create comprehensive commit analysis for Claude
COMMIT_ANALYSIS="Git Repository Analysis for Commit Squashing

COMMITS TO COMBINE ($COMMIT_COUNT commits):
$COMMIT_DETAILS

FILES CHANGED:
$FILE_CHANGES

CHANGE SUMMARY:
$DIFF_SUMMARY

BRANCH: $CURRENT_BRANCH
TARGET: $BASE_BRANCH branch

Please analyze these commits and create a single, professional commit message that:
1. Uses conventional commit format (feat:, fix:, refactor:, etc.)
2. Has a clear, concise subject line (50 characters or less)
3. Includes a detailed body explaining what was accomplished
4. Groups related changes logically
5. Is suitable for merging to $BASE_BRANCH branch

Respond with ONLY the commit message, no other text or explanations."

echo "🤖 Generating commit message with Claude CLI..."

# Generate commit message using Claude CLI
NEW_COMMIT_MESSAGE=$(echo "$COMMIT_ANALYSIS" | claude -p "Create a professional git commit message based on this analysis")

# Check if Claude generated a valid response
if [ -z "$NEW_COMMIT_MESSAGE" ] || [ "$NEW_COMMIT_MESSAGE" = "null" ]; then
    echo "❌ Error: Claude CLI failed to generate commit message"
    echo "🔧 Falling back to manual commit message..."
    
    # Fallback commit message
    COMMIT_TYPE="feat"
    if echo "$COMMIT_DETAILS" | grep -qi "fix\|bug\|error"; then
        COMMIT_TYPE="fix"
    elif echo "$COMMIT_DETAILS" | grep -qi "refactor\|clean\|improve"; then
        COMMIT_TYPE="refactor"
    fi
    
    NEW_COMMIT_MESSAGE="$COMMIT_TYPE: combine $COMMIT_COUNT commits for $BASE_BRANCH

$(git log --format="- %s" $BASE_BRANCH..HEAD | tac)

Files modified: $(echo "$FILE_CHANGES" | wc -l) files
Ready for $BASE_BRANCH branch merge"
fi

echo "✅ Claude generated commit message:"
echo "----------------------------------------"
echo "$NEW_COMMIT_MESSAGE"
echo "----------------------------------------"

# Confirm before proceeding
read -p "🤔 Proceed with squashing commits? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Aborted. No changes made."
    git branch -D "$BACKUP_BRANCH"
    exit 1
fi

echo "🔄 Squashing commits..."

# Soft reset to base branch (keeps all changes staged)
git reset --soft $BASE_BRANCH

# Create single commit with Claude-generated message
git commit -m "$NEW_COMMIT_MESSAGE"

echo "✅ Successfully squashed $COMMIT_COUNT commits into 1 commit"
echo "💾 Backup created: $BACKUP_BRANCH"

# Show the result
echo "📊 Final result:"
git log --oneline -1
echo ""
echo "📝 Full commit message:"
echo "----------------------------------------"
git log -1 --format="%B"
echo "----------------------------------------"
echo ""
echo "🚀 Ready to push and create PR to $BASE_BRANCH branch!"
echo ""
echo "Next steps:"
echo "1. git push --force-with-lease origin $CURRENT_BRANCH"
echo "2. Create PR from $CURRENT_BRANCH to $BASE_BRANCH"
echo ""
echo "If something went wrong, restore with:"
echo "git reset --hard $BACKUP_BRANCH"
echo "git branch -D $BACKUP_BRANCH  # Clean up backup"