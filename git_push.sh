#!/bin/bash

# GitHub 用户名
GITHUB_USER="wjl-bupt"


# 参数：$1 为访问令牌，$2 为目标分支
GITHUB_TOKEN="$1"
FEATURE_BRANCH="$2"

if [ -z "$GITHUB_TOKEN" ] || [ -z "$FEATURE_BRANCH" ]; then
  echo "❌ 用法: $0 <GitHub访问令牌> <目标分支名>"
  echo "✅ 示例: ./git_push.sh ghp_xxx weijun_formal"
  exit 1
fi

CODE_DIR="."
REPO_URL="https://github.com/wjl-bupt/gorge_walk.git"
TEMP_BRANCH="temp_${GITHUB_USER}_$(date +%s)"

cd "$CODE_DIR" || { echo "目录不存在"; exit 1; }

if [ ! -d ".git" ]; then
  git init
  git remote add origin "$REPO_URL"
fi

git checkout -B "$TEMP_BRANCH"

git add .
git commit -m "自动提交：$TEMP_BRANCH"

git push "https://$GITHUB_USER:$GITHUB_TOKEN@github.com/wjl-bupt/gorge_walk.git" "$TEMP_BRANCH" --force

if git show-ref --quiet refs/heads/"$FEATURE_BRANCH"; then
  git checkout "$FEATURE_BRANCH"
else
  git checkout -b "$FEATURE_BRANCH"
  git push "https://$GITHUB_USER:$GITHUB_TOKEN@github.com/wjl-bupt/gorge_walk.git" "$FEATURE_BRANCH" --set-upstream --force
fi

git merge "$TEMP_BRANCH"
git push "https://$GITHUB_USER:$GITHUB_TOKEN@github.com/wjl-bupt/gorge_walk.git" "$FEATURE_BRANCH"

git branch -D "$TEMP_BRANCH"
git push "https://$GITHUB_USER:$GITHUB_TOKEN@github.com/wjl-bupt/gorge_walk.git" --delete "$TEMP_BRANCH"

git remote remove origin
rm -rf .git

echo "✅ 推送完成：$TEMP_BRANCH 合并入 $FEATURE_BRANCH，已清理本地仓库"
