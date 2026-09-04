#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
#  迪加(diplus-www) 优化覆盖包 一键安装脚本
#
#  前提: 车机已用官方脚本安装 diplus 基础版
#        (bash <(curl -sSL http://lanye.pw/diplus))
#
#  用法: 把本脚本 install.sh 和 diplus-opt.tar.gz 上传到你
#        的服务器/NAS同一目录, 然后别人在车机Termux执行:
#        bash <(curl -sSL https://你的域名/install.sh)
#
#  ⚠ 重要: 请把下面 BASE_URL 改成你的实际下载地址!
# ==========================================================
BASE_URL="https://raw.githubusercontent.com/xch1986/diplus-opt/main"   # GitHub raw

set -e
HOME_DIR=/data/data/com.termux/files/home
WWW=$HOME_DIR/www
TMP=/data/local/tmp/diplus-opt
rm -rf $TMP && mkdir -p $TMP

echo "[1/4] 下载优化包..."
curl -sSL "$BASE_URL/diplus-opt.tar.gz" -o $TMP/diplus-opt.tar.gz
if [ ! -s $TMP/diplus-opt.tar.gz ]; then echo "❌ 下载失败, 请检查 BASE_URL"; exit 1; fi

echo "[2/4] 解压..."
tar xzf $TMP/diplus-opt.tar.gz -C $TMP

echo "[3/4] 覆盖优化文件..."
cp -f $TMP/www/*.html $WWW/ 2>/dev/null || true
cp -f $TMP/www/api/alarm.php $WWW/api/ 2>/dev/null || true
mkdir -p $WWW/api $WWW/view $WWW/includes
cp -f $TMP/www/api/*.php $WWW/api/ 2>/dev/null || true
cp -f $TMP/www/view/*.vue $WWW/view/ 2>/dev/null || true
cp -f $TMP/www/includes/*.php $WWW/includes/ 2>/dev/null || true
chmod 644 $WWW/*.html $WWW/alarm.php $WWW/api/*.php $WWW/view/*.vue 2>/dev/null || true
if [ -f $TMP/nginx/nginx.conf ]; then
  mkdir -p $HOME_DIR/nginx
  cp -f $TMP/nginx/nginx.conf $HOME_DIR/nginx/nginx.conf
  chmod 644 $HOME_DIR/nginx/nginx.conf
fi

echo "[4/4] 重启 nginx..."
if [ -f $HOME_DIR/nginx/nginx.pid ]; then
  kill -HUP $(cat $HOME_DIR/nginx/nginx.pid) 2>/dev/null || pkill nginx 2>/dev/null || true
fi

echo ""
echo "============================================"
echo "✅ 迪加优化包安装完成！"
echo "   浏览器打开 http://<车机IP>:8018/ 查看效果"
echo "============================================"
