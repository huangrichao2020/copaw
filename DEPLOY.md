# 📊 股票报告系统 - 部署说明

超哥，股票报告系统已创建完成，需要你登录 Gitee 完成最后推送。

## ✅ 已创建文件

```
/Users/tingchi/stock_report/
├── index.html      # Vue 3 前端页面（含图表）
├── api_data.json   # A 股市场数据
└── .git/           # Git 仓库已初始化
```

## 🚀 推送步骤

### 1. 登录 Gitee
访问：https://gitee.com/login
- 账号：`huangrichao`
- 密码：`huang.123581321`

### 2. 创建仓库
访问：https://gitee.com/new
- 仓库名称：`stock_report`
- 公开/私有：公开
- 初始化：❌ 不要勾选（我们已有代码）

### 3. 推送代码
```bash
cd /Users/tingchi/stock_report

# 如果之前添加了远程仓库，先删除
git remote remove gitee 2>/dev/null || true

# 添加远程仓库（使用你的账号）
git remote add gitee https://gitee.com/huangrichao/stock_report.git

# 推送
git push -u gitee main
```

### 4. 配置 Pages
访问：https://gitee.com/huangrichao/stock_report/pages
- 来源分支：`main`
- 生成目录：`/`
- 点击「启动」

## 🌐 访问地址

部署成功后：
**https://huangrichao.gitee.io/stock_report/**

## 📊 系统功能

- 📈 市场统计（成交额、涨跌家数、涨停数）
- 📊 指数行情（上证指数等）
- 📉 指数 K 线图（ECharts 渲染）
- 📊 涨跌分布柱状图
- 🔥 热门板块 TOP10（龙一龙二、封板时间）
- 🏆 涨停股 TOP20

## 💡 每日更新

```bash
# 手动更新数据
cd /Users/tingchi/stock_report
# 替换 api_data.json 为最新数据
git add .
git commit -m "📊 更新 $(date +%Y-%m-%d)"
git push
```

## 🔧 如果推送失败

### 方案 1: 使用 Personal Access Token
1. 访问：https://gitee.com/profile/personal_access_tokens
2. 创建 Token（勾选 projects）
3. 使用：
```bash
git remote set-url gitee https://<TOKEN>@gitee.com/huangrichao/stock_report.git
git push
```

### 方案 2: 使用 SSH
```bash
# 生成 SSH Key
ssh-keygen -t ed25519 -C "huangrichao@email.com"

# 添加公钥到 Gitee
# https://gitee.com/profile/sshkeys

# 切换远程 URL
git remote set-url gitee git@gitee.com:huangrichao/stock_report.git
git push
```

---

**创建时间**: 2026-03-09  
**维护者**: 小超 🦞
