#!/usr/bin/env bash
set -euo pipefail

if [ -f package.json ]; then
  if ! node -e "require.resolve('@playwright/test')" >/dev/null 2>&1; then
    echo "Installing @playwright/test..."
    npm install -D @playwright/test
  fi
  echo "Installing Playwright browsers..."
  npx playwright install
else
  echo "No package.json found. Initialize Node project first (npm init -y) and re-run."
  exit 1
fi
