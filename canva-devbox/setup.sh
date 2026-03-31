#!/bin/bash

# Clone my repos
git clone https://github.com/francescoferraioli/scripts.git

git clone https://github.com/francescoferraioli/ff.git

git clone https://github.com/canvanauts/frankie-claude.git

# Setup otter mcp
# Do this after cloning and creating the links as it sets things up in
# the correct place for otter claude code to work and for mcp to be
# installed in the correct place.
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

./install.sh
./create-links.sh