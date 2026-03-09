#!/bin/bash
# 配置股票报告系统定时任务
# 用法：./setup_cron.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTO_UPDATE_SCRIPT="$SCRIPT_DIR/auto_update.sh"

echo "⏰ 配置股票报告系统定时任务"
echo "=========================="
echo ""

# 检查脚本是否存在
if [ ! -f "$AUTO_UPDATE_SCRIPT" ]; then
    echo "❌ 找不到 auto_update.sh"
    exit 1
fi

# 确保脚本可执行
chmod +x "$AUTO_UPDATE_SCRIPT"

# 显示当前 cron 任务
echo "📋 当前定时任务："
crontab -l 2>/dev/null || echo "（无定时任务）"
echo ""

# 创建新的 cron 任务
CRON_JOB="0 17 * * 1-5 cd $SCRIPT_DIR && ./auto_update.sh >> $SCRIPT_DIR/auto_update.log 2>&1"

echo "📝 将添加以下定时任务："
echo "   $CRON_JOB"
echo ""
echo "   含义：每个交易日（周一至周五）17:00 自动更新数据"
echo ""

# 询问是否继续
read -p "是否继续？(y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 已取消"
    exit 0
fi

# 添加定时任务
(crontab -l 2>/dev/null | grep -v "auto_update.sh" || true; echo "$CRON_JOB") | crontab -

echo ""
echo "✅ 定时任务已配置！"
echo ""
echo "📋 验证："
crontab -l | grep "auto_update"
echo ""
echo "📄 日志文件：$SCRIPT_DIR/auto_update.log"
echo ""
echo "💡 管理命令："
echo "   查看任务：crontab -l"
echo "   编辑任务：crontab -e"
echo "   删除任务：crontab -r"
echo "   查看日志：tail -f $SCRIPT_DIR/auto_update.log"
