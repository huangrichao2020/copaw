#!/bin/bash
# 股票报告系统 - 自动更新数据并推送
# 用法：./auto_update.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "📊 股票报告系统 - 自动更新"
echo "=========================="
echo "📅 时间：$(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 1. 检查是否是交易日（周一至周五 9:00-17:00）
DAY_OF_WEEK=$(date +%u)
HOUR=$(date +%H)

if [ "$DAY_OF_WEEK" -gt 5 ]; then
    echo "⚠️  周末，跳过更新"
    exit 0
fi

if [ "$HOUR" -lt 9 ] || [ "$HOUR" -gt 17 ]; then
    echo "⚠️  非交易时间，跳过更新"
    exit 0
fi

echo "✅ 交易时间，开始更新..."
echo ""

# 2. 运行 Python 数据更新脚本
echo "🔄 获取最新市场数据..."
if python3 "$SCRIPT_DIR/update_data.py"; then
    echo "✅ 数据获取成功"
else
    echo "❌ 数据获取失败，使用备用数据"
    python3 "$SCRIPT_DIR/generate_data.py" || exit 1
fi

echo ""

# 3. 检查是否有变化
echo "📝 检查文件变化..."
if git status --porcelain | grep -q "api_data.json"; then
    echo "✅ 发现数据变化"
else
    echo "ℹ️  数据无变化，跳过推送"
    exit 0
fi

# 4. 提交更改
echo ""
echo "💾 提交更改..."
git add api_data.json
git commit -m "📊 自动更新 $(date +%Y-%m-%d)" || echo "无新更改"

# 5. 推送到 Gitee
echo ""
echo "🔄 推送到 Gitee..."

# 检查远程仓库
if ! git remote | grep -q gitee; then
    echo "添加远程仓库..."
    git remote add gitee https://gitee.com/huangrichao/stock_report.git
fi

# 推送（使用静默模式，避免密码提示）
if git push -u gitee master --quiet 2>/dev/null; then
    echo "✅ 推送成功！"
    echo ""
    echo "🌐 访问地址：https://huangrichao.gitee.io/stock_report/"
else
    echo "⚠️  推送失败（可能需要认证）"
    echo ""
    echo "💡 解决方案："
    echo "   1. 配置 SSH Key（推荐）："
    echo "      ssh-keygen -t ed25519 -C 'huangrichao@email.com'"
    echo "      添加公钥到：https://gitee.com/profile/sshkeys"
    echo "      git remote set-url gitee git@gitee.com:huangrichao/stock_report.git"
    echo ""
    echo "   2. 或使用 Personal Access Token："
    echo "      https://gitee.com/profile/personal_access_tokens"
fi

echo ""
echo "✅ 更新完成！"
