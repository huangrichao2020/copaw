#!/bin/bash
# 测试 Gitee 连接和推送

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

GITEE_USER="huangrichao"
GITEE_REPO="stock_report"

echo "🧪 测试 Gitee 连接"
echo "=================="
echo ""

# 1. 检查远程仓库
echo "1️⃣  检查远程仓库配置..."
if git remote | grep -q gitee; then
    REMOTE_URL=$(git remote get-url gitee)
    echo "   ✅ 远程仓库：gitee"
    echo "   📍 URL: $REMOTE_URL"
else
    echo "   ⚠️  未配置 gitee 远程仓库"
    echo ""
    read -p "是否添加？(y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote add gitee https://gitee.com/$GITEE_USER/$GITEE_REPO.git
        echo "   ✅ 已添加远程仓库"
    else
        echo "   ❌ 已取消"
        exit 1
    fi
fi

echo ""

# 2. 测试 HTTPS 连接
echo "2️⃣  测试 HTTPS 连接..."
echo "   账号：$GITEE_USER"
echo "   密码：tingchi2021"
echo ""
echo "   尝试获取仓库信息..."

if git ls-remote gitee >/dev/null 2>&1; then
    echo "   ✅ HTTPS 连接成功！"
else
    echo "   ❌ HTTPS 连接失败"
    echo ""
    echo "   💡 解决方案："
    echo "   1. 检查账号密码是否正确"
    echo "   2. 使用 SSH Key（推荐）："
    echo "      ./setup_ssh.sh"
    echo "   3. 使用 Personal Access Token："
    echo "      https://gitee.com/profile/personal_access_tokens"
fi

echo ""

# 3. 检查当前分支
echo "3️⃣  检查当前分支..."
BRANCH=$(git branch --show-current)
echo "   📍 当前分支：$BRANCH"

if [ "$BRANCH" != "master" ] && [ "$BRANCH" != "main" ]; then
    echo "   ⚠️  建议切换到 master 或 main 分支"
fi

echo ""

# 4. 检查 Git 状态
echo "4️⃣  检查 Git 状态..."
STATUS=$(git status --porcelain)
if [ -n "$STATUS" ]; then
    echo "   ⚠️  有待提交的更改："
    git status --short
else
    echo "   ✅ 工作区干净"
fi

echo ""

# 5. 测试推送
echo "5️⃣  测试推送..."
read -p "是否现在测试推送？(y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "   创建测试文件..."
    echo "# Test" > test_push.txt
    echo "Test file for push" >> test_push.txt
    
    git add test_push.txt
    git commit -m "test: 测试推送"
    
    if git push -u gitee "$BRANCH"; then
        echo "   ✅ 推送成功！"
        
        # 清理测试文件
        git reset --hard HEAD~1
        rm -f test_push.txt
        echo "   ✅ 已清理测试文件"
    else
        echo "   ❌ 推送失败"
        echo ""
        echo "   💡 请运行 ./setup_ssh.sh 配置 SSH Key"
        
        # 回滚
        git reset --hard HEAD~1 2>/dev/null || true
        rm -f test_push.txt
    fi
else
    echo "   ⚠️  跳过推送测试"
fi

echo ""
echo "=================="
echo "✅ 测试完成！"
echo ""
echo "📋 下一步："
echo "   1. 如果连接成功：运行 ./quick_setup.sh 配置自动更新"
echo "   2. 如果连接失败：运行 ./setup_ssh.sh 配置 SSH Key"
echo ""
