#!/bin/bash
# push_merge_cleanup.sh

# ========= 可自定义部分 ==========
REMOTE="origin"
USER_BRANCH="weijun"
REMOTE_URL="git@github.com:wjl-bupt/gorge_walk.git"
# =================================

# 自动生成临时分支名
TMP_BRANCH="tmp/${USER_BRANCH}-$(date +%Y%m%d-%H%M%S)"

# 设置远程（仅首次添加有效）
git remote add $REMOTE $REMOTE_URL 2>/dev/null

# 创建并切换到临时分支
git checkout -b $TMP_BRANCH

# 添加、提交并推送
git add .
git commit -m "Temporary commit from $USER_BRANCH"
git push $REMOTE $TMP_BRANCH

# 切换回自己的主分支
git checkout $USER_BRANCH

# 获取临时分支（如果未自动追踪）
git fetch $REMOTE $TMP_BRANCH

# 合并临时分支
git merge --no-ff $REMOTE/$TMP_BRANCH -m "Merge $TMP_BRANCH into $USER_BRANCH"

# 推送合并结果
git push $REMOTE $USER_BRANCH

# 删除远程临时分支
git push $REMOTE --delete $TMP_BRANCH

# 删除本地临时分支
git branch -D $TMP_BRANCH

echo "✅ 合并完成，已删除临时分支：$TMP_BRANCH"

