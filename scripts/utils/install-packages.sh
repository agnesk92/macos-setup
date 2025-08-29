# Install packages managed outside Brew
#!/usr/bin/env bash

set -euo pipefail

# claude-code
npm install -g @anthropic-ai/claude-code

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
nvm install --lts
