#!/bin/bash
# 股票报告系统 - 一键配置
# 用法：./quick_setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🚀 股票报告系统 - 一键配置"
echo "=========================="
echo ""

# 1. 检查 Git 状态
echo "📦 检查 Git 状态..."
if [ ! -d ".git" ]; then
    echo "❌ 不是 Git 仓库，请先初始化"
    exit 1
fi

# 检查远程仓库
if ! git remote | grep -q gitee; then
    echo "添加 Gitee 远程仓库..."
    git remote add gitee https://gitee.com/huangrichao/stock_report.git
fi
echo "✅ Git 配置正常"
echo ""

# 2. 配置 SSH
echo "🔑 步骤 1/3：配置 SSH Key"
echo ""
read -p "是否配置 SSH Key？（推荐，可避免密码输入）(y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    chmod +x setup_ssh.sh
    ./setup_ssh.sh
else
    echo "⚠️  跳过 SSH 配置（推送时可能需要密码）"
fi

echo ""
echo "------------------------"
echo ""

# 3. 测试更新脚本
echo "🧪 步骤 2/3：测试更新脚本"
echo ""
chmod +x auto_update.sh
read -p "是否现在测试数据更新？(y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./auto_update.sh || echo "⚠️  测试失败，稍后可手动运行"
else
    echo "⚠️  跳过测试"
fi

echo ""
echo "------------------------"
echo ""

# 4. 配置定时任务
echo "⏰ 步骤 3/3：配置定时任务"
echo ""
read -p "是否配置定时任务？（每个交易日 17:00 自动更新）(y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    chmod +x setup_cron.sh
    ./setup_cron.sh
else
    echo "⚠️  跳过定时任务配置"
fi

echo ""
echo "=========================="
echo "✅ 配置完成！"
echo ""
echo "📋 下一步："
echo ""
echo "1. 如果是首次使用，请推送代码到 Gitee："
echo "   git add ."
echo "   git commit -m '初始提交'"
echo "   git push -u gitee master"
echo ""
echo "2. 配置 Gitee Pages："
echo "   访问：https://gitee.com/huangrichao/stock_report/pages"
echo "   来源分支：master"
echo "   生成目录：/"
echo "   点击「启动」"
echo ""
echo "3. 查看访问地址："
echo "   https://huangrichao.gitee.io/stock_report/"
echo ""
echo "📄 详细文档：AUTO_UPDATE_README.md"
echo ""
