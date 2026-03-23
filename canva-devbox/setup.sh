#!/bin/bash
./dotfiles/canva-devbox/create-links.sh

# Install diff-so-fancy
npm install -g diff-so-fancy

# Install fonts and starship
sudo apt install fonts-powerline
curl -sS https://starship.rs/install.sh | sh

# Setup otter mcp
otter config mcp enable-all
otter claude-code mcp add otter -- otter mcp serve

# Setup Jira MCP
otter config mcp secret jira_email frankief@canva.com
otter config mcp secret jira_url https://canva.atlassian.net
# Get Jira API token from 1Password
printf '%s\n' "On your local machine, run:"
printf '%s\n' '  op read "op://Employee/Frankie JIRA Token/password" | pbcopy'
printf '%s\n' "Then paste the token here."
read -rs -p "Jira API token: " JIRA_TOKEN
echo
otter config mcp secret jira_api_token "$JIRA_TOKEN"
unset JIRA_TOKEN

# Clone my repos
git clone https://github.com/francescoferraioli/scripts.git

git clone https://github.com/francescoferraioli/ff.git

git clone https://github.com/canvanauts/frankie-claude.git
./frankie-claude/create-links.sh
