# 迪加 (diplus-www) 优化覆盖包

针对 BYD 宋PLUS DM-i 车机 Termux 部署的 diplus-www (迪加 web) 深度优化版。

## 包含的优化

### 界面
- 顶部/左侧统一 10 项菜单: 首页|哨兵|行驶数据|file browser|openlist|frp|lucky|推送设置|首页参数|通用设置
- 手机端左侧竖排菜单(68px 紧凑), 电脑端横向菜单(18px 字号)
- openlist / lucky / 哨兵 / 行驶数据 / file browser 全部 iframe 选项卡嵌套
- lucky 中文界面
- 首页车况卡片(车辆位置/停车时长/电量油量/胎压) + 教程卡片
- 行驶数据表格/油价电价概览

### 功能
- 哨兵视频筛选: 有人/有车/晃动/振动, 阈值与车机 config_M.dat 同步
- 微信/钉钉推送: "有人(有车) 且(晃动或振动)" 逻辑
- 推送页晃动/振动阈值保存后同步到哨兵筛选(config_M.dat)
- 视频进度条事件标记: 蓝色进度>红色有人>黄色有车, 点击图标跳转事件
- 通用设置: USB常通电开关/视频缩略图/移动视频/自动清理/亮度
- nginx 反代 openlist(同源) + 静态资源加速

## 文件说明
- `install-self.sh`   自包含安装脚本(内嵌全部优化文件, 一个文件搞定, 推荐!)
- `install.sh`        在线安装脚本(需配 BASE_URL 指向你的 tar.gz)
- `diplus-opt.tar.gz` 优化文件压缩包(install.sh 的下载源)
- `README.md`         本说明

## 安装前提
车机已用官方脚本安装 diplus 基础版:
```bash
bash <(curl -sSL http://lanye.pw/diplus)
```

## 安装方式一: 自包含脚本 (推荐, 适用飞牛等网盘分享)

1. 浏览器打开分享链接, 下载 `install-self.sh`
2. 把 install-self.sh 传到车机 Termux (可用 adb push / U盘 / 微信传文件)
3. 在车机 Termux 执行:
```bash
bash install-self.sh
```
(脚本内已包含全部优化文件, 无需联网下载)

## 安装方式二: 在线一键 (适用 GitHub/Gitee/静态服务器)

1. 把 `install.sh` 和 `diplus-opt.tar.gz` 上传到同一目录
2. 编辑 install.sh 把 `BASE_URL` 改成你的下载地址
3. 别人在车机 Termux 执行:
```bash
bash <(curl -sSL https://你的域名/install.sh)
```
注意: 飞牛网盘分享链接带签名校验, 不支持 curl 直接下载, 请用方式一。

## 文件结构
```
diplus-opt/
├── www/
│   ├── settings.html  index.html  video_list.html  alarm.php
│   ├── alarm_details.html  alarm_details_car.html  sum.html  sv_video3.html
│   ├── api/   (settings_msg.php  settings_general.php  openlist.php ...)
│   ├── view/  (settings_msg.vue  settings_general.vue  ...)
│   └── includes/share.php
└── nginx/nginx.conf
```

## 备注
- 覆盖包为增量版, 需先装官方基础版
- 配置文件路径均为 Termux 默认 (home/www, home/nginx)
- 车机 IP 通过无线 adb 部署 (UFI root 中转)
