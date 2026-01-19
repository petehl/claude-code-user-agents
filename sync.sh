#!/bin/bash

# Claude Code Agents Sync Script
# Bidirectional sync between ~/.claude and this git repository
# Features: conflict detection, selective sync, dry-run, backups

set -e  # Exit on error

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if git is available
if ! command -v git &> /dev/null; then
    log_error "git is not installed or not in PATH"
    exit 1
fi

# Initialize git repo if not exists
if [ ! -d "$REPO_DIR/.git" ]; then
    log_warning "Git repository not initialized"
    log_info "Initializing git repository..."
    cd "$REPO_DIR"
    git init
    log_success "Git repository initialized"
fi

# Create directory structure
mkdir -p "$REPO_DIR/agents"
mkdir -p "$REPO_DIR/skills"
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/skills"

# Function to check for conflicts
check_conflicts() {
    local source_dir="$1"
    local dest_dir="$2"
    local conflicts=0

    for file in "$source_dir"/*; do
        [ -e "$file" ] || continue
        local filename=$(basename "$file")
        local dest_file="$dest_dir/$filename"

        if [ -f "$dest_file" ]; then
            # Both files exist - check if different
            if ! cmp -s "$file" "$dest_file"; then
                log_warning "Conflict detected: $filename"
                echo "  Source: $(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$file")"
                echo "  Dest:   $(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$dest_file")"
                conflicts=$((conflicts + 1))
            fi
        fi
    done

    return $conflicts
}

# Function to check if sync is needed
# Returns 0 (success) if changes are needed, 1 (failure) if up to date
check_sync_needed() {
    local source_dir="$1"
    local dest_dir="$2"

    for file in "$source_dir"/*; do
        [ -e "$file" ] || continue
        local filename=$(basename "$file")
        local dest_file="$dest_dir/$filename"

        # Skip hidden files and backups
        if [[ "$filename" == .* ]] || [[ "$filename" == *~ ]]; then
            continue
        fi

        if [ ! -f "$dest_file" ]; then
            # File doesn't exist in dest - needs sync
            return 0
        elif ! cmp -s "$file" "$dest_file"; then
            # File exists but is different - needs sync
            return 0
        fi
    done

    # No changes needed
    return 1
}

# Function to sync files
sync_files() {
    local source_dir="$1"
    local dest_dir="$2"
    local dry_run="$3"
    local count=0

    for file in "$source_dir"/*; do
        [ -e "$file" ] || continue
        local filename=$(basename "$file")
        local dest_file="$dest_dir/$filename"

        # Skip hidden files and backups
        if [[ "$filename" == .* ]] || [[ "$filename" == *~ ]]; then
            continue
        fi

        if [ "$dry_run" == "true" ]; then
            if [ ! -f "$dest_file" ]; then
                log_info "[DRY-RUN] Would copy: $filename (new)"
            elif ! cmp -s "$file" "$dest_file"; then
                log_info "[DRY-RUN] Would update: $filename (modified)"
            fi
        else
            if [ ! -f "$dest_file" ]; then
                cp "$file" "$dest_file"
                log_success "Copied: $filename (new)"
                count=$((count + 1))
            elif ! cmp -s "$file" "$dest_file"; then
                cp "$file" "$dest_file"
                log_success "Updated: $filename (modified)"
                count=$((count + 1))
            fi
        fi
    done

    if [ "$dry_run" != "true" ] && [ $count -gt 0 ]; then
        log_success "Synced $count file(s)"
    elif [ "$dry_run" != "true" ]; then
        log_info "No changes to sync"
    fi
}

# Function to create backup
create_backup() {
    local backup_dir="$CLAUDE_DIR/backups/$(date '+%Y%m%d_%H%M%S')"
    mkdir -p "$backup_dir"

    if [ -d "$CLAUDE_DIR/agents" ]; then
        cp -r "$CLAUDE_DIR/agents" "$backup_dir/"
    fi
    if [ -d "$CLAUDE_DIR/skills" ]; then
        cp -r "$CLAUDE_DIR/skills" "$backup_dir/"
    fi

    log_success "Backup created: $backup_dir"

    # Keep only last 5 backups
    ls -dt "$CLAUDE_DIR/backups"/*/ 2>/dev/null | tail -n +6 | xargs rm -rf 2>/dev/null || true
}

# Push command - save ~/.claude to repo
cmd_push() {
    local dry_run="false"
    local force="false"
    local message=""

    # Parse flags
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                dry_run="true"
                shift
                ;;
            --force|-f)
                force="true"
                shift
                ;;
            -m|--message)
                message="$2"
                shift 2
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    log_info "Pushing from ~/.claude to repo..."

    # Check for conflicts unless force
    if [ "$force" != "true" ]; then
        if check_conflicts "$CLAUDE_DIR/agents" "$REPO_DIR/agents" ||
           check_conflicts "$CLAUDE_DIR/skills" "$REPO_DIR/skills"; then
            log_error "Conflicts detected! Use --force to override or resolve manually"
            exit 1
        fi
    fi

    # Sync agents
    if [ -d "$CLAUDE_DIR/agents" ] && [ "$(ls -A "$CLAUDE_DIR/agents" 2>/dev/null)" ]; then
        log_info "Syncing agents..."
        sync_files "$CLAUDE_DIR/agents" "$REPO_DIR/agents" "$dry_run"
    fi

    # Sync skills
    if [ -d "$CLAUDE_DIR/skills" ] && [ "$(ls -A "$CLAUDE_DIR/skills" 2>/dev/null)" ]; then
        log_info "Syncing skills..."
        sync_files "$CLAUDE_DIR/skills" "$REPO_DIR/skills" "$dry_run"
    fi

    if [ "$dry_run" == "true" ]; then
        log_info "Dry run complete. Use without --dry-run to apply changes."
        exit 0
    fi

    # Git commit
    cd "$REPO_DIR"

    if git diff --quiet && git diff --cached --quiet; then
        log_info "No changes to commit"
        exit 0
    fi

    git add agents/ skills/ 2>/dev/null || true

    if [ -z "$message" ]; then
        message="Update: $(date '+%Y-%m-%d %H:%M:%S')"
    fi

    git commit -m "$message"
    log_success "Changes committed: $message"

    # Push to remote if configured
    if git remote | grep -q origin; then
        log_info "Pushing to remote..."
        if git push; then
            log_success "Pushed to remote repository"
        else
            log_warning "Failed to push to remote (may need to set up remote)"
        fi
    else
        log_warning "No remote configured. Use: git remote add origin <url>"
    fi
}

# Pull command - restore repo to ~/.claude
cmd_pull() {
    local dry_run="false"
    local force="false"
    local backup="true"

    # Parse flags
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                dry_run="true"
                shift
                ;;
            --force|-f)
                force="true"
                shift
                ;;
            --no-backup)
                backup="false"
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    log_info "Pulling from repo to ~/.claude..."

    # Create backup unless disabled
    if [ "$backup" == "true" ] && [ "$dry_run" != "true" ]; then
        create_backup
    fi

    # Check for conflicts unless force
    if [ "$force" != "true" ]; then
        if check_conflicts "$REPO_DIR/agents" "$CLAUDE_DIR/agents" ||
           check_conflicts "$REPO_DIR/skills" "$CLAUDE_DIR/skills"; then
            log_error "Conflicts detected! Use --force to override"
            log_info "Your current files are backed up in ~/.claude/backups/"
            exit 1
        fi
    fi

    # Sync agents
    if [ -d "$REPO_DIR/agents" ] && [ "$(ls -A "$REPO_DIR/agents" 2>/dev/null)" ]; then
        log_info "Syncing agents..."
        sync_files "$REPO_DIR/agents" "$CLAUDE_DIR/agents" "$dry_run"
    fi

    # Sync skills
    if [ -d "$REPO_DIR/skills" ] && [ "$(ls -A "$REPO_DIR/skills" 2>/dev/null)" ]; then
        log_info "Syncing skills..."
        sync_files "$REPO_DIR/skills" "$CLAUDE_DIR/skills" "$dry_run"
    fi

    if [ "$dry_run" == "true" ]; then
        log_info "Dry run complete. Use without --dry-run to apply changes."
    else
        log_success "Pull complete!"
    fi
}

# Status command - show what would change
cmd_status() {
    log_info "Checking sync status..."
    echo ""

    echo -e "${BLUE}━━━ Push Status (local → repo) ━━━${NC}"
    if check_sync_needed "$CLAUDE_DIR/agents" "$REPO_DIR/agents"; then
        log_warning "Agents: changes to push"
    else
        log_info "Agents: up to date"
    fi
    if check_sync_needed "$CLAUDE_DIR/skills" "$REPO_DIR/skills"; then
        log_warning "Skills: changes to push"
    else
        log_info "Skills: up to date"
    fi

    echo ""
    echo -e "${BLUE}━━━ Pull Status (repo → local) ━━━${NC}"
    if check_sync_needed "$REPO_DIR/agents" "$CLAUDE_DIR/agents"; then
        log_warning "Agents: changes to pull"
    else
        log_info "Agents: up to date"
    fi
    if check_sync_needed "$REPO_DIR/skills" "$CLAUDE_DIR/skills"; then
        log_warning "Skills: changes to pull"
    else
        log_info "Skills: up to date"
    fi

    echo ""
    echo -e "${BLUE}━━━ Git Status ━━━${NC}"
    cd "$REPO_DIR"
    git status -s agents/ skills/ 2>/dev/null || log_info "No git changes"

    echo ""
    echo -e "${BLUE}━━━ Summary ━━━${NC}"
    local agent_count=$(find "$CLAUDE_DIR/agents" -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    local skill_count=$(find "$CLAUDE_DIR/skills" -type f -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
    local repo_agent_count=$(find "$REPO_DIR/agents" -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    local repo_skill_count=$(find "$REPO_DIR/skills" -mindepth 2 -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
    echo "Local agents: $agent_count"
    echo "Local skills: $skill_count"
    echo "Repo agents: $repo_agent_count"
    echo "Repo skills: $repo_skill_count"

    if git remote | grep -q origin; then
        echo "Remote: $(git remote get-url origin)"
    else
        echo "Remote: not configured"
    fi
}

# List command - show all agents and skills
cmd_list() {
    echo -e "${BLUE}━━━ Agents in ~/.claude/agents/ ━━━${NC}"
    if [ -d "$CLAUDE_DIR/agents" ]; then
        find "$CLAUDE_DIR/agents" -type f -name "*.md" | while read file; do
            echo "  - $(basename "$file" .md)"
        done
    else
        log_info "No agents found"
    fi

    echo ""
    echo -e "${BLUE}━━━ Skills in ~/.claude/skills/ ━━━${NC}"
    if [ -d "$CLAUDE_DIR/skills" ]; then
        find "$CLAUDE_DIR/skills" -mindepth 2 -name "SKILL.md" | while read file; do
            local skill_name=$(basename "$(dirname "$file")")
            echo "  - $skill_name"
        done
    else
        log_info "No skills found"
    fi
}

# Init command - setup repository
cmd_init() {
    local remote_url="$1"

    log_info "Initializing Claude agents backup..."

    # Initialize git if needed
    cd "$REPO_DIR"
    if [ ! -d ".git" ]; then
        git init
        log_success "Git repository initialized"
    fi

    # Create .gitignore
    cat > .gitignore << 'EOF'
# Exclude sensitive files
.claude.json
*.local.*

# Exclude OS files
.DS_Store
Thumbs.db

# Exclude editor files
*.swp
*.swo
*~
EOF
    log_success "Created .gitignore"

    # Create README
    cat > README.md << 'EOF'
# Claude Code Agents Backup

Personal backup of Claude Code agents and skills.

## Usage

```bash
# Save local agents to this repo
./sync.sh push

# Restore agents from repo to local
./sync.sh pull

# Check sync status
./sync.sh status

# List all agents/skills
./sync.sh list
```

## Setup on New Machine

```bash
git clone <your-repo-url> ~/github/claude-agents-backup
cd ~/github/claude-agents-backup
./sync.sh pull
```
EOF
    log_success "Created README.md"

    # Add remote if provided
    if [ -n "$remote_url" ]; then
        if git remote | grep -q origin; then
            git remote set-url origin "$remote_url"
            log_success "Remote origin updated: $remote_url"
        else
            git remote add origin "$remote_url"
            log_success "Remote origin added: $remote_url"
        fi
    fi

    # Initial commit
    git add .
    if git commit -m "Initial setup"; then
        log_success "Initial commit created"
    fi

    echo ""
    log_info "Next steps:"
    echo "  1. Copy your agents: cp ~/.claude/agents/* agents/"
    echo "  2. Run: ./sync.sh push"
    echo "  3. Push to GitHub: git push -u origin main"
}

# Help command
cmd_help() {
    cat << 'EOF'
Claude Code Agents Sync Script

USAGE:
    ./sync.sh <command> [options]

COMMANDS:
    push            Save ~/.claude agents/skills to repo
    pull            Restore repo agents/skills to ~/.claude
    status          Show sync status and conflicts
    list            List all agents and skills
    init [url]      Initialize repository (optionally with remote URL)
    help            Show this help message

PUSH OPTIONS:
    --dry-run       Show what would be synced without making changes
    --force, -f     Override conflicts and sync anyway
    -m, --message   Custom git commit message

PULL OPTIONS:
    --dry-run       Show what would be synced without making changes
    --force, -f     Override conflicts and sync anyway
    --no-backup     Don't create backup before pulling

EXAMPLES:
    # Check what would change
    ./sync.sh push --dry-run

    # Save with custom message
    ./sync.sh push -m "Added new agents"

    # Restore from repo (creates backup first)
    ./sync.sh pull

    # Force pull without backup
    ./sync.sh pull --force --no-backup

    # Check status
    ./sync.sh status

BACKUP:
    Backups are automatically created in ~/.claude/backups/
    Last 5 backups are kept, older ones are deleted automatically.

EOF
}

# Main command dispatcher
case "${1:-help}" in
    push)
        shift
        cmd_push "$@"
        ;;
    pull)
        shift
        cmd_pull "$@"
        ;;
    status)
        cmd_status
        ;;
    list)
        cmd_list
        ;;
    init)
        cmd_init "$2"
        ;;
    help|--help|-h)
        cmd_help
        ;;
    *)
        log_error "Unknown command: $1"
        echo "Run './sync.sh help' for usage information"
        exit 1
        ;;
esac
