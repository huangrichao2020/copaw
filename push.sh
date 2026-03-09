#!/bin/bash
# 股票报告系统 - 一键推送脚本

set -e

REPO_DIR="/Users/tingchi/stock_report"
GITEE_USER="huangrichao"
GITEE_REPO="stock_report"

echo "🚀 股票报告系统推送脚本"
echo "======================"
echo ""

cd "$REPO_DIR"

# 检查 Git 状态
echo "📦 当前状态:"
git status --short

# 添加更改
echo ""
echo "📝 添加更改..."
git add .

# 提交
echo "💾 提交更改..."
git commit -m "📊 自动更新 $(date +%Y-%m-%d %H:%M)" || echo "无更改"

# 检查远程仓库
echo ""
echo "🔗 检查远程仓库..."
if ! git remote | grep -q gitee; then
    echo "添加远程仓库..."
    git remote add gitee https://gitee.com/$GITEE_USER/$GITEE_REPO.git
fi

# 推送
echo ""
echo "🔄 推送到 Gitee..."
echo "💡 提示：如果提示认证失败，请输入 Gitee 账号密码"
echo "   账号：$GITEE_USER"
echo "   密码：tingchi2021"
echo ""

if git push -u gitee main; then
    echo ""
    echo "✅ 推送成功！"
    echo ""
    echo "📄 下一步：配置 Gitee Pages"
    echo "   1. 访问：https://gitee.com/$GITEE_USER/$GITEE_REPO/pages"
    echo "   2. 来源分支：main"
    echo "   3. 生成目录：/"
    echo "   4. 点击「启动」"
    echo ""
    echo "🌐 访问地址：https://$GITEE_USER.gitee.io/$GITEE_REPO/"
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "解决方案："
    echo "1. 检查账号密码是否正确"
    echo "2. 使用 Personal Access Token:"
    echo "   git remote set-url gitee https://<TOKEN>@gitee.com/$GITEE_USER/$GITEE_REPO.git"
    echo "3. 使用 SSH Key（推荐）:"
    echo "   ssh-keygen -t ed25519"
    echo "   添加公钥到：https://gitee.com/profile/sshkeys"
    echo "   git remote set-url gitee git@gitee.com:$GITEE_USER/$GITEE_REPO.git"
fi
