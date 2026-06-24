#!/bin/bash

# ============================
# 1. Forza il target D50
# ============================
sed -i 's/CONFIG_TARGET.*/CONFIG_TARGET_ipq50xx=y/' .config
sed -i 's/CONFIG_TARGET_ipq50xx.*/CONFIG_TARGET_ipq50xx=y/' .config
sed -i 's/CONFIG_TARGET_ipq50xx_generic.*/CONFIG_TARGET_ipq50xx_generic=y/' .config

grep -q "CONFIG_TARGET_ipq50xx_generic_DEVICE_xunison_exigo_d50=y" .config || \
echo "CONFIG_TARGET_ipq50xx_generic_DEVICE_xunison_exigo_d50=y" >> .config

# ============================
# 2. Copia i file del target
# ============================
mkdir -p target/linux/ipq50xx
mkdir -p target/linux/ipq50xx/image
mkdir -p target/linux/ipq50xx/files/arch/arm64/boot/dts/qcom

cp $GITHUB_WORKSPACE/d50/Makefile target/linux/ipq50xx/Makefile
cp $GITHUB_WORKSPACE/d50/generic.mk target/linux/ipq50xx/generic.mk
cp $GITHUB_WORKSPACE/d50/image.mk target/linux/ipq50xx/image/Makefile

# ============================
# 3. Copia il DTS del D50
# ============================
cp $GITHUB_WORKSPACE/d50/ipq5018-exigo-hub-d50-5g.dts \
   target/linux/ipq50xx/files/arch/arm64/boot/dts/qcom/

# ============================
# 4. Feed modem (come già fai)
# ============================
rm -rf package/luci-app-exigod50
git clone https://github.com/Dave333-ak47/d50-modem-feed package/luci-app-exigod50

# ============================
# 5. Copia firmware WiFi
# ============================
mkdir -p package/base-files/files/lib/firmware/

if [ -d "wi-fi" ]; then
    cp -r wi-fi/Bdwlan* package/base-files/files/lib/firmware/
else
    cp -r Bdwlan* package/base-files/files/lib/firmware/ 2>/dev/null
fi

echo "D50: diy-part2.sh completato"

