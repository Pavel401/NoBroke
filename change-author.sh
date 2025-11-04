#!/bin/bash

# Configuration
OLD_NAME="Mabud"
OLD_EMAIL="mabud.alam@featsclub.com"
NEW_NAME="Pavel401"
NEW_EMAIL="pavelalam401@gmail.com"

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "❌ Error: Not a git repository. Please run this script from the root of a git repository."
    exit 1
fi

REPO_NAME=$(basename "$PWD")
CURRENT_BRANCH=$(git branch --show-current)

echo "=========================================="
echo "Repository: $REPO_NAME"
echo "Path: $PWD"
echo "Current Branch: $CURRENT_BRANCH"
echo "=========================================="
echo "This will change all commits from:"
echo "  $OLD_NAME <$OLD_EMAIL>"
echo "To:"
echo "  $NEW_NAME <$NEW_EMAIL>"
echo ""

# Fetch latest changes from remote
if git remote -v | grep -q "origin"; then
    echo "Fetching latest changes from remote..."
    git fetch --all
    echo "✓ Fetch completed"
    echo ""
else
    echo "⚠ No remote 'origin' configured. Skipping fetch."
    echo ""
fi

# Check if there are any commits by the old author
if git log --all --author="$OLD_NAME" --oneline 2>/dev/null | head -5 | grep -q .; then
    echo "Found commits by $OLD_NAME:"
    git log --all --author="$OLD_NAME" --oneline | head -5
    echo ""
    echo "Total commits by $OLD_NAME: $(git log --all --author="$OLD_NAME" --oneline | wc -l | tr -d ' ')"
    echo ""
else
    echo "ℹ No commits by $OLD_NAME found in any branch."
    read -p "Continue anyway? (y/n): " answer
    if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
        echo "Aborted."
        exit 0
    fi
fi

echo "⚠️  WARNING: This will rewrite git history!"
echo "⚠️  This is a destructive operation and will require force push."
echo ""
read -p "Continue with rewriting history? (y/n): " answer
if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "=========================================="
echo "Processing All Branches"
echo "=========================================="

# Get all local branches
LOCAL_BRANCHES=$(git branch | sed 's/^[* ]*//')
BRANCH_COUNT=0
PROCESSED_BRANCHES=""

# Get all remote branches and create local tracking branches if they don't exist
echo "Fetching remote branches..."
for remote_branch in $(git branch -r | grep -v '\->' | grep 'origin/' | sed 's/origin\///'); do
    if ! git branch | grep -q "^[* ]*$remote_branch$"; then
        echo "Creating local branch for: $remote_branch"
        git branch "$remote_branch" "origin/$remote_branch" 2>/dev/null || true
    fi
done

# Get updated list of all local branches
ALL_BRANCHES=$(git branch | sed 's/^[* ]*//')

echo ""
echo "Found branches:"
echo "$ALL_BRANCHES" | sed 's/^/  - /'
echo ""

# Rewrite history for all branches
for branch in $ALL_BRANCHES; do
    echo "Processing branch: $branch"
    
    git filter-branch -f --env-filter "
    if [ \"\$GIT_COMMITTER_NAME\" = \"$OLD_NAME\" ] || [ \"\$GIT_AUTHOR_NAME\" = \"$OLD_NAME\" ]; then
        export GIT_COMMITTER_NAME=\"$NEW_NAME\"
        export GIT_COMMITTER_EMAIL=\"$NEW_EMAIL\"
        export GIT_AUTHOR_NAME=\"$NEW_NAME\"
        export GIT_AUTHOR_EMAIL=\"$NEW_EMAIL\"
    fi
    if [ \"\$GIT_COMMITTER_EMAIL\" = \"$OLD_EMAIL\" ] || [ \"\$GIT_AUTHOR_EMAIL\" = \"$OLD_EMAIL\" ]; then
        export GIT_COMMITTER_NAME=\"$NEW_NAME\"
        export GIT_COMMITTER_EMAIL=\"$NEW_EMAIL\"
        export GIT_AUTHOR_NAME=\"$NEW_NAME\"
        export GIT_AUTHOR_EMAIL=\"$NEW_EMAIL\"
    fi
    " -- "$branch" 2>&1 | grep -v "^Rewrite" | grep -v "^WARNING"
    
    BRANCH_COUNT=$((BRANCH_COUNT + 1))
    PROCESSED_BRANCHES="$PROCESSED_BRANCHES  ✓ $branch\n"
    echo "  ✓ Completed: $branch"
    echo ""
done

echo "=========================================="
echo "✓ History rewritten successfully"
echo "=========================================="
echo -e "Processed branches:"
echo -e "$PROCESSED_BRANCHES"
echo "Total branches processed: $BRANCH_COUNT"
echo ""

# Verify the changes
echo "=========================================="
echo "Verification"
echo "=========================================="
if git log --all --author="$OLD_NAME" --oneline 2>/dev/null | head -1 | grep -q .; then
    echo "⚠️  Warning: Still found commits by $OLD_NAME"
    git log --all --author="$OLD_NAME" --oneline | head -3
else
    echo "✓ No commits by $OLD_NAME found (verification passed)"
fi

echo ""
echo "Sample of commits after changes:"
for branch in $(git branch | sed 's/^[* ]*//' | head -3); do
    echo ""
    echo "Branch: $branch"
    git log "$branch" --oneline -2 2>/dev/null | sed 's/^/  /'
done
echo ""

# Check if there's a remote configured
if git remote -v | grep -q "origin"; then
    echo "=========================================="
    echo "⚠️  FORCE PUSH WARNING"
    echo "=========================================="
    echo "This will force push ALL branches to remote:"
    git branch | sed 's/^[* ]*//' | sed 's/^/  - /'
    echo ""
    echo "All collaborators will need to reset their local copies."
    echo ""
    read -p "Push ALL branches to remote now? (y/n): " push_answer
    if [ "$push_answer" = "y" ] || [ "$push_answer" = "Y" ]; then
        echo ""
        echo "=========================================="
        echo "Force Pushing All Branches"
        echo "=========================================="
        
        PUSH_COUNT=0
        FAILED_PUSHES=""
        
        # Push each branch individually
        for branch in $(git branch | sed 's/^[* ]*//' ); do
            echo "Pushing branch: $branch"
            if git push origin "$branch" --force 2>&1; then
                echo "  ✓ Pushed: $branch"
                PUSH_COUNT=$((PUSH_COUNT + 1))
            else
                echo "  ❌ Failed: $branch"
                FAILED_PUSHES="$FAILED_PUSHES  - $branch\n"
            fi
            echo ""
        done
        
        echo "=========================================="
        echo "Push Summary"
        echo "=========================================="
        echo "Successfully pushed: $PUSH_COUNT branches"
        
        if [ -n "$FAILED_PUSHES" ]; then
            echo ""
            echo "Failed to push:"
            echo -e "$FAILED_PUSHES"
        fi
        
        # Also push tags if any
        if git tag | grep -q .; then
            echo ""
            echo "Pushing tags..."
            if git push --force --tags 2>&1; then
                echo "✓ Tags pushed successfully"
            else
                echo "⚠️  Warning: Failed to push tags"
            fi
        fi
        
        echo ""
        echo "✓ Force push completed!"
        echo ""
        echo "📝 Note for collaborators:"
        echo "   They should run: git fetch origin && git reset --hard origin/<branch-name>"
    else
        echo ""
        echo "ℹ Skipped pushing. To push manually later, run:"
        echo "  git push origin <branch-name> --force"
        echo ""
        echo "Or push all branches:"
        for branch in $(git branch | sed 's/^[* ]*//' ); do
            echo "  git push origin $branch --force"
        done
    fi
else
    echo "⚠ No remote 'origin' configured."
fi

# Clean up filter-branch refs
if [ -d .git/refs/original ]; then
    echo ""
    echo "Cleaning up filter-branch backup refs..."
    git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d
    echo "✓ Cleanup completed"
fi

echo ""
echo "=========================================="
echo "Done!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  Repository: $REPO_NAME"
echo "  Old author: $OLD_NAME <$OLD_EMAIL>"
echo "  New author: $NEW_NAME <$NEW_EMAIL>"
echo "  Total branches processed: $BRANCH_COUNT"
if [ -n "$PUSH_COUNT" ]; then
    echo "  Branches pushed: $PUSH_COUNT"
fi
echo ""
