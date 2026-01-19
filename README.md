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
