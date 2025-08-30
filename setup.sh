#!/usr/bin/env bash

set -e

echo "🚀 Starting macOS setup..."

echo "📋 Running basic setup..."
# bash scripts/setup-basics.sh

echo "⚙️  Running config setup..."
bash scripts/setup-configs.sh

echo "🛠️  Running macOS preferences setup..."
# bash scripts/setup-macos.sh

echo "✅ Setup complete!"
