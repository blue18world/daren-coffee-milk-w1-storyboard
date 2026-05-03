#!/bin/bash
# 大人牛乳 W1 分鏡網頁 - GitHub Pages 部署腳本
set -e

cd "$(dirname "$0")"

REPO_URL="https://github.com/blue18world/daren-coffee-milk-w1-storyboard.git"
REPO_OWNER="blue18world"
REPO_NAME="daren-coffee-milk-w1-storyboard"

echo "==> 初始化 git..."
if [ ! -d .git ]; then
  git init -b main
fi

echo "==> 設定遠端..."
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"

echo "==> 拉取現有 README..."
git fetch origin main 2>/dev/null || true
git reset --soft origin/main 2>/dev/null || true

echo "==> 加入所有檔案..."
git add -A

echo "==> Commit..."
git commit -m "Add W1 storyboard files (HTML + 20 shot images)" 2>/dev/null || echo "(沒有新變更)"

echo "==> 推到 GitHub..."
git push -u origin main

echo "==> 啟用 GitHub Pages..."
gh api -X POST "repos/$REPO_OWNER/$REPO_NAME/pages" \
  -f "source[branch]=main" \
  -f "source[path]=/" 2>/dev/null \
  || gh api -X PUT "repos/$REPO_OWNER/$REPO_NAME/pages" \
       -f "source[branch]=main" \
       -f "source[path]=/" 2>/dev/null \
  || echo "Pages 可能已啟用，繼續..."

echo ""
echo "✅ 完成！"
echo ""
echo "📦 Repo：https://github.com/$REPO_OWNER/$REPO_NAME"
echo "🌐 網頁：https://$REPO_OWNER.github.io/$REPO_NAME/"
echo ""
echo "（Pages 第一次建置需要 1-2 分鐘才會生效）"
