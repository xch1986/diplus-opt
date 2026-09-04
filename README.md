# 迪加 (diplus-www) 优化完整扩展包

基于 diplus-www (作者 @甲壳虫) 的深度优化版, **车机 Termux 一键完整安装, 无需先装原版**。

**出处**: 原项目 https://github.com/cnjackchen/diplus-www

---

## 🚀 一键安装

车机 Termux 直接执行:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/xch1986/diplus-opt/main/install.sh)
```

脚本自动完成:
1. 下载完整扩展包 (home.tar, Release v1.0-opt)
2. 部署到 ~/
3. 自动安装依赖 (nginx / php / php-fpm / ffmpeg / sqlite / frp 等)
4. 启动车机 web 服务

完成后访问: **http://车机IP:8018** (默认账号 admin / 123456)

> ⚠ GitHub 访问慢/失败时, 用浏览器打开
> https://github.com/xch1986/diplus-opt/releases/download/v1.0-opt/home.tar
> 手动下载 home.tar 放到 ~/ 后重跑 install.sh 即可。

---

## 包含的优化

### 界面
- 统一 10 项菜单: 首页|哨兵|行驶数据|file browser|openlist|frp|lucky|推送设置|首页参数|通用设置
- 手机端左侧竖排菜单(68px 紧凑), 电脑端横向菜单(18px 字号)
- openlist / lucky / 哨兵 / 行驶数据 / file browser 全部 iframe 选项卡嵌套
- lucky 中文界面
- 首页车况卡片(车辆位置/停车时长/电量油量/胎压) + 教程卡片
- 行驶数据表格/油价电价概览

### 功能
- 哨兵视频筛选: 有人/有车/晃动/振动, 阈值与车机 config_M.dat 同步
- 微信/钉钉推送: "有人(有车) 且(晃动或振动)" 逻辑, 推送完整显示晃动/振动数值
- 推送页晃动/振动阈值保存后同步到哨兵筛选(config_M.dat)
- 视频进度条事件标记: 蓝色进度>红色有人>黄色有车, 点击图标跳转事件
- 通用设置: USB常通电开关/视频缩略图/移动视频/自动清理/亮度
- nginx 反代 openlist(同源) + 静态资源加速

## 文件说明
- `install.sh`        一键安装脚本 (下载 release home.tar, 完整安装)
- `home.tar`          完整扩展包 (Release v1.0-opt 资产)
- `install-self.sh`   自包含安装脚本 (内嵌全部优化文件, 适用于飞牛等网盘分享)
- `diplus-opt.tar.gz` 增量覆盖包 (适用于已装原版, 仅覆盖优化文件)

## 安装前提
车机已安装 Termux 且开启 ADB 无线调试 (DiLink 车机)。

## 默认账号
- Web / Lucky / FileBrowser: **admin / 123456** (首次登录后请修改)
- SSH: 用户名 `$(whoami)`, 密码 `123456`

## 远程访问
编辑 `~/frp/frpc.toml` 填入你的 frp 服务器地址和 token, 然后在 web 管理页启用 frp。

## 常见问题
- GitHub 下载慢: 使用代理镜像, 或手动下载 home.tar
- 安装后 web 打不开: 确认 nginx/php-fpm 已启动 (`pgrep -f nginx`)
- 推送不触发: 检查微信推送 webhook 配置和"有人/有车"开关
