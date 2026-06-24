#!/bin/bash

echo "=== D50: Inizio diy-part2.sh ==="

# ============================
# 1. Forza il target D50
# ============================
sed -i 's/CONFIG_TARGET.*/CONFIG_TARGET_qualcommax=y/' .config
sed -i 's/CONFIG_TARGET_qualcommax.*/CONFIG_TARGET_qualcommax=y/' .config
sed -i 's/CONFIG_TARGET_qualcommax_ipq50xx.*/CONFIG_TARGET_qualcommax_ipq50xx=y/' .config

grep -q "CONFIG_TARGET_qualcommax_ipq50xx_DEVICE_xunison_exigo_d50=y" .config || \
echo "CONFIG_TARGET_qualcommax_ipq50xx_DEVICE_xunison_exigo_d50=y" >> .config

# ============================
# 2. Crea struttura target
# ============================
mkdir -p target/linux/qualcommax/ipq50xx
mkdir -p target/linux/qualcommax/ipq50xx/image
mkdir -p target/linux/qualcommax/files/arch/arm64/boot/dts/qcom

# ============================
# 3. Copia Makefile del target
# ============================
cp $GITHUB_WORKSPACE/target/linux/qualcommax/ipq50xx/generic.mk \
   target/linux/qualcommax/ipq50xx/generic.mk

cp $GITHUB_WORKSPACE/openwrt/target/linux/qualcommax/ipq50xx/image/Makefile \
   target/linux/qualcommax/ipq50xx/image/Makefile

# Se hai creato il Makefile principale, copialo:
if [ -f "$GITHUB_WORKSPACE/openwrt/target/linux/qualcommax/ipq50xx/Makefile" ]; then
    cp $GITHUB_WORKSPACE/openwrt/target/linux/qualcommax/ipq50xx/Makefile \
       target/linux/qualcommax/ipq50xx/Makefile
fi

# ============================
# 4. Copia DTS del D50
# ============================
cp $GITHUB_WORKSPACE/openwrt/target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq5018-exigo-hub-d50-5g.dts \
   target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/

# ============================
# 5. Feed modem D50
# ============================
rm -rf package/luci-app-exigod50
git clone https://github.com/Dave333-ak47/d50-modem-feed package/luci-app-exigod50

# ============================
# 6. Copia firmware WiFi Bdwlan
# ============================
mkdir -p package/base-files/files/lib/firmware/

if [ -d "$GITHUB_WORKSPACE/wi-fi" ]; then
    cp -r $GITHUB_WORKSPACE/wi-fi/Bdwlan* package/base-files/files/lib/firmware/
fi

# ============================
# 7. Imposta IP LAN 192.168.1.1
# ============================
mkdir -p package/base-files/files/etc/config
cat << 'EOF' > package/base-files/files/etc/config/network
config interface 'lan'
        option device 'br-lan'
        option proto 'static'
        option ipaddr '192.168.1.1'
        option netmask '255.255.255.0'
EOF

# ============================
# 8. Root senza password
# ============================
mkdir -p package/base-files/files/etc
cat << 'EOF' > package/base-files/files/etc/shadow
root::0:0:99999:7:::
EOF

cat << 'EOF' > package/base-files/files/etc/passwd
root::0:0:root:/root:/bin/ash
EOF

# ============================
# 9. LuCI in italiano
# ============================
echo "CONFIG_PACKAGE_luci-i18n-base-it=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-firewall-it=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-opkg-it=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-system-it=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-network-it=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-wireless-it=y" >> .config

echo "=== D50: diy-part2.sh completato ==="
