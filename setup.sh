#!/usr/bin/env bash

set -e

echo "🚀 Starting macOS setup..."

# Run basic setup
echo "📋 Running basic setup..."
bash scripts/setup-basics.sh

# Run config setup
echo "⚙️  Running config setup..."
bash scripts/setup-configs.sh

echo "✅ Setup complete!"