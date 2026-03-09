# 📊 股票报告系统 - 自动更新配置指南

## 🚀 快速开始

### 第一步：配置 SSH（推荐）

解决 Gitee 推送认证问题，避免每次输入密码：

```bash
cd /Users/tingchi/.copaw/projects/stock_report
./setup_ssh.sh
```

按照提示操作：
1. 生成 SSH Key（如果还没有）
2. 复制公钥到 Gitee：https://gitee.com/profile/sshkeys
3. 切换远程仓库 URL 为 SSH 地址

### 第二步：配置定时任务

设置每个交易日自动更新数据：

```bash
./setup_cron.sh
```

按照提示确认，会自动添加 cron 任务：
- **执行时间**：每个交易日（周一至周五）17:00
- **执行内容**：获取最新数据 → 提交 → 推送到 Gitee

---

## 📁 文件说明

```
stock_report/
├── auto_update.sh      # 自动更新脚本（核心）
├── setup_cron.sh       # 配置定时任务脚本
├── setup_ssh.sh        # 配置 SSH Key 脚本
├── update_data.py      # 获取真实数据（Tushare）
├── generate_data.py    # 生成备用数据
├── api_data.json       # 市场数据（自动更新）
├── index.html          # 前端页面
└── push.sh             # 手动推送脚本
```

---

## ⏰ 定时任务管理

### 查看当前任务
```bash
crontab -l
```

### 编辑任务
```bash
crontab -e
```

### 删除所有任务
```bash
crontab -r
```

### 查看更新日志
```bash
tail -f /Users/tingchi/.copaw/projects/stock_report/auto_update.log
```

---

## 🔄 手动更新

### 方式一：一键更新
```bash
cd /Users/tingchi/.copaw/projects/stock_report
./auto_update.sh
```

### 方式二：分步执行
```bash
# 1. 更新数据
python3 update_data.py

# 2. 提交更改
git add api_data.json
git commit -m "📊 更新 $(date +%Y-%m-%d)"

# 3. 推送
git push gitee master
```

---

## 🔧 故障排查

### 问题 1：推送失败（认证错误）

**解决方案**：使用 SSH Key
```bash
./setup_ssh.sh
```

或使用 Personal Access Token：
```bash
# 1. 访问 https://gitee.com/profile/personal_access_tokens 创建 Token
# 2. 切换远程 URL
git remote set-url gitee https://<TOKEN>@gitee.com/huangrichao/stock_report.git
```

### 问题 2：数据获取失败

**原因**：Tushare API 限制或网络问题

**解决方案**：
- 脚本会自动使用备用数据（generate_data.py）
- 检查日志：`cat auto_update.log`

### 问题 3：定时任务不执行

**检查**：
```bash
# 1. 查看 cron 服务状态（macOS）
sudo systemctl status cron  # Linux
launchctl list | grep cron   # macOS

# 2. 查看 cron 日志
grep CRON /var/log/system.log  # macOS
grep CRON /var/log/cron.log    # Linux

# 3. 测试脚本
./auto_update.sh
```

---

## 📊 数据说明

### 数据来源
- **Tushare Pro**：A 股行情数据（https://tushare.pro）
- **备用数据**：当 API 不可用时使用模拟数据

### 更新内容
- 市场统计（成交额、涨跌家数、涨停数）
- 指数行情（上证指数、深证成指等）
- 热门板块
- 涨停股 TOP20

### 数据格式
```json
{
  "trade_date": "20260309",
  "market_stats": {
    "total_amount": 2.18,
    "up": 3350,
    "down": 1720,
    "limit_up": 118,
    "sentiment": 66.1
  },
  "today_sectors": [...],
  "top_stocks": [...],
  "index_data": {...}
}
```

---

## 🌐 访问地址

部署成功后访问：
**https://huangrichao.gitee.io/stock_report/**

---

## 💡 高级配置

### 修改更新频率

编辑 cron 任务：
```bash
crontab -e
```

示例（每天 15:30 更新）：
```
30 15 * * 1-5 cd /Users/tingchi/.copaw/projects/stock_report && ./auto_update.sh >> auto_update.log 2>&1
```

### 多市场支持

修改 `update_data.py` 添加更多数据源：
- 港股（HKEX）
- 美股（Finnhub）
- 加密货币（CoinGecko）

### 告警通知

在 `auto_update.sh` 末尾添加：
```bash
# 失败时发送飞书通知
if [ $? -ne 0 ]; then
    curl -X POST https://open.feishu.cn/open-apis/bot/v2/hook/YOUR_WEBHOOK \
    -H "Content-Type: application/json" \
    -d '{"msg_type":"text","content":{"text":"股票数据更新失败！"}}'
fi
```

---

## 📞 支持

如有问题，请联系：
- Gitee：https://gitee.com/huangrichao
- 邮箱：huangrichao@email.com

---

**最后更新**：2026-03-09  
**维护者**：小超 🦞
