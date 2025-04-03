#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <git_repo_url>"
  exit 1
fi

REPO_URL="$1"
TMP_DIR="tmp_submission_check"
TEST_DIR="playwright-tests"

rm -rf "$TMP_DIR"
mkdir "$TMP_DIR"
cd "$TMP_DIR" || exit 1

git clone "$REPO_URL" repo
if [ $? -ne 0 ]; then
  echo "Git clone failed."
  exit 1
fi

cd repo || exit 1
git checkout submission_hw1
# Install dependencies
npm install || { echo "npm install failed"; exit 1; }
npx playwright install || { echo "Playwright install failed"; exit 1; }

# Ports to free
PORTS=(3000 3001)

for PORT in "${PORTS[@]}"; do
  echo "Checking port $PORT..."

  PID=$(lsof -ti tcp:$PORT)

  if [ -n "$PID" ]; then
    echo "Killing process $PID on port $PORT"
    kill -9 "$PID" || echo "Failed to kill process $PID"
  else
    echo "No process found on port $PORT"
  fi
done

# Start JSON server
npx json-server --port 3001 --watch ./data/notes.json > backend.log 2>&1 &
BACK_PID=$!
sleep 1

# Start frontend
npm run dev > frontend.log 2>&1 &
FRONT_PID=$!
sleep 1

# a basic Playwright test
mkdir "$TEST_DIR"
cat > "$TEST_DIR/test.spec.js" <<EOF
import { test, expect } from '@playwright/test';

test('check note and pagination button', async ({ page }) => {
  await page.goto('http://localhost:3000');
  const notes = page.locator('.note');
  await expect(notes).toHaveCount(10); // for example
  await expect(page.locator('button[name="first"]')).toBeVisible();
});
EOF

# Playwright config
cat > playwright.config.js <<EOF
import { test, expect, defineConfig } from '@playwright/test';
export default defineConfig({
  testDir: './$TEST_DIR',
  timeout: 10000,
  use: {
    headless: true,
  },
});
EOF

cat > vite.config.ts <<EOF
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
  },
});
EOF

npx playwright test || {
  echo "Test failed."
  kill $BACK_PID $FRONT_PID
  exit 1
}

kill $BACK_PID $FRONT_PID
exit 0
