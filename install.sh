#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
#  迪加(diplus-www) 优化版 一键安装脚本
#  (无需先装原版, 直接完整安装)
#
#  出处: 本优化包基于 diplus-www (作者 @甲壳虫)
#        原项目: https://github.com/cnjackchen/diplus-www
#  优化项目: https://github.com/xch1986/diplus-opt
#
#  用法: 车机 Termux 直接执行:
#  bash <(curl -sSL https://raw.githubusercontent.com/xch1986/diplus-opt/main/install.sh)
# ==========================================================
home="/data/data/com.termux/files/home"
version="2.8.1-opt"
hometar_url="https://github.com/xch1986/diplus-opt/releases/download/v1.0-opt/home.tar"

echo ""
echo "=============================================="
echo " 比亚迪车机 Termux 扩展包(优化版) 一键安装"
echo "=============================================="
echo ""
echo "本脚本将自动完成:"
echo "  1. 下载优化扩展包(home.tar) 并部署到 ~/"
echo "  2. 自动安装依赖 (nginx/php/php-fpm/ffmpeg/sqlite/frp 等)"
echo "  3. 启动车机 web 服务 (nginx + php-fpm)"
echo ""
echo "📌 出处: 本优化包基于 diplus-www (作者 @甲壳虫)"
echo "       原项目 github.com/cnjackchen/diplus-www"
echo "       优化项 github.com/xch1986/diplus-opt"
echo ""

read -p "是否继续安装? (y/n): " choice
if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
    echo "已取消安装。"
    exit 1
fi

# ---------- 下载 ----------
echo ""
echo "[1/4] 下载优化扩展包 ..."
if [ -f "$home/home.tar" ]; then
    rm "$home/home.tar"
fi
curl -L "$hometar_url" -o "$home/home.tar"
if [ ! -s "$home/home.tar" ]; then
    echo "❌ 下载失败! 请检查网络 (GitHub 可能需要代理/科学上网)。"
    echo "   备选: 浏览器打开 $hometar_url 手动下载 home.tar 到 ~/ 后重跑本脚本"
    exit 1
fi
echo "✅ 下载完成 ($(du -h "$home/home.tar" | cut -f1))"

# ---------- sqlite ----------
if ! command -v sqlite3 > /dev/null; then
    echo "[2/4] 安装 sqlite ..."
    pkg install sqlite -y
fi

# ---------- 备份 .bashrc ----------
if [ -f "$home/.bashrc" ]; then
    mv "$home/.bashrc" "$home/.bashrc.bak"
fi

# ---------- 解压部署 ----------
echo "[3/4] 部署扩展包到 ~/ ..."
tar -xf "$home/home.tar" -C /data/data/com.termux/files/

# 更新版本号
if [ -f "$home/db/db.db" ]; then
    sqlite3 "$home/db/db.db" "UPDATE settings SET data='$version' WHERE app = 'global' AND param = 'version'" 2>/dev/null || true
fi

# ---------- 初始化 ----------
echo "[4/4] 运行 ~/.bashrc 初始化 (自动安装依赖并启动服务, 可能需要几分钟)..."
bash "$home/.bashrc" install

echo ""
echo "=============================================="
echo " ✅ 部署完成!"
echo "=============================================="
echo "  车机浏览器访问:  http://127.0.0.1:8018"
echo "  同网设备访问:    http://车机IP:8018"
echo "  默认账号:        admin / 123456 (首次登录后请修改)"
echo ""
echo "  ⚠ 远程访问说明: 编辑 ~/frp/frpc.toml 填入你的 frp 服务器"
echo "    地址和 token, 然后在web 管理页启用 frp 即可远程访问。"
echo "    如未配置 frp, 则仅局域网可访问。"
echo ""
echo "  优化项目: https://github.com/xch1986/diplus-opt"
echo "  祝您用车愉快!"
