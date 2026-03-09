#!/bin/bash
# 配置 Gitee SSH Key
# 用法：./setup_ssh.sh

set -e

GITEE_USER="huangrichao"
GITEE_REPO="stock_report"

echo "🔑 配置 Gitee SSH Key"
echo "===================="
echo ""

# 检查是否已有 SSH Key
if [ -f ~/.ssh/id_ed25519.pub ]; then
    echo "✅ 已有 SSH Key"
    echo ""
    echo "公钥内容："
    cat ~/.ssh/id_ed25519.pub
    echo ""
else
    echo "📝 生成新的 SSH Key..."
    echo ""
    read -p "输入邮箱（可选，直接回车跳过）: " EMAIL
    
    if [ -n "$EMAIL" ]; then
        ssh-keygen -t ed25519 -C "$EMAIL"
    else
        ssh-keygen -t ed25519 -C "$GITEE_USER@email.com"
    fi
    echo ""
    echo "✅ SSH Key 已生成"
    echo ""
    echo "公钥内容："
    cat ~/.ssh/id_ed25519.pub
    echo ""
fi

echo "📋 下一步操作："
echo ""
echo "1. 复制上面的公钥内容（以 ssh-ed25519 开头）"
echo ""
echo "2. 访问：https://gitee.com/profile/sshkeys"
echo ""
echo "3. 点击「添加公钥」"
echo "   - 标题：MacBook Pro（或自定义）"
echo "   - 公钥：粘贴上面复制的内容"
echo "   - 点击「确定」"
echo ""
echo "4. 切换远程仓库 URL："
echo "   cd /Users/tingchi/.copaw/projects/stock_report"
echo "   git remote set-url gitee git@gitee.com:$GITEE_USER/$GITEE_REPO.git"
echo ""
echo "5. 测试连接："
echo "   ssh -T git@gitee.com"
echo ""

read -p "是否现在切换远程仓库 URL？(y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd "$(dirname "$0")"
    
    # 检查是否有 gitee 远程
    if git remote | grep -q gitee; then
        git remote set-url gitee git@gitee.com:$GITEE_USER/$GITEE_REPO.git
        echo "✅ 远程仓库 URL 已更新"
    else
        git remote add gitee git@gitee.com:$GITEE_USER/$GITEE_REPO.git
        echo "✅ 已添加远程仓库"
    fi
    
    echo ""
    echo "🧪 测试连接..."
    if ssh -T git@gitee.com 2>&1 | grep -q "successfully"; then
        echo "✅ SSH 连接成功！"
    else
        echo "⚠️  SSH 连接失败，请先在 Gitee 添加公钥"
    fi
fi

echo ""
echo "✅ 配置完成！"
