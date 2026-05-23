#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#

# 1. Imposta l'IP di default del router (Opzionale: scommenta se vuoi forzarlo a 172.30.55.1)
# sed -i 's/192.168.1.1/172.30.55.1/g' package/base-files/files/bin/config_generate

# 2. Rimuovi eventuali pacchetti duplicati che potrebbero andare in conflitto
rm -rf package/luci-app-exigod50

# 3. Clona il feed personalizzato per la gestione del modem 5G e del band locking
git clone https://github.com/Dave333-ak47/d50-modem-feed package/luci-app-exigod50

# 4. Crea la struttura delle cartelle per i firmware statici di OpenWrt
mkdir -p package/base-files/files/lib/firmware/

# 5. Iniezione automatica dei file di calibrazione Wi-Fi Bdwlan dell'Exigo D50
# Cerca i file sia nella root che nella cartella 'wi-fi/' e li copia nella partizione finale
if [ -d "wi-fi" ]; then
    echo "Rilevata cartella wi-fi, copia dei file Bdwlan in corso..."
    cp -r wi-fi/Bdwlan* package/base-files/files/lib/firmware/
else
    echo "Copia dei file Bdwlan dalla directory principale in corso..."
    cp -r Bdwlan* package/base-files/files/lib/firmware/ 2>/dev/null
fi

echo "Script diy-part2.sh eseguito con successo!"
