#!/bin/bash

declare -a urls=(

# Rom URLs
'http://bigota.d.miui.com/8.4.12/miui_MIMIX2_8.4.12_72acbd32f8_8.0.zip'

)

EU_VER=8.4.12

declare -a eu_urls=(

# EU Rom URLs
'https://jaist.dl.sourceforge.net/project/xiaomi-eu-multilang-miui-roms/xiaomi.eu/MIUI-WEEKLY-RELEASES/8.4.12/xiaomi.eu_multi_MIMix2S_8.4.12_v9-8.0.zip'

)

command -v dirname >/dev/null 2>&1 && cd "$(dirname "$0")"
if [[ "$1" == "rom" ]]; then
    base_dir=/sdcard/TWRP
    [ -z "$2" ] && VER="$EU_VER" || VER=$2
    [ -d "$base_dir" ] || base_dir=.
    aria2c_opts="--check-certificate=false --file-allocation=trunc -s10 -x10 -j10 -c"
    aria2c="aria2c $aria2c_opts -d $base_dir/$VER"
    for i in "${eu_urls[@]}"
    do
        $aria2c ${i//$EU_VER/$VER}
    done
    base_url="https://github.com/linusyang92/mipay-extract/releases/download/$VER"
    $aria2c $base_url/eufix-MiMix2-$VER.zip
    $aria2c $base_url/mipay-MIMIX2-$VER.zip
    $aria2c $base_url/weather-MiMix2-$VER-mod.apk
    exit 0
fi
for i in "${urls[@]}"
do
   bash extract.sh "$i" || exit 1
done
[[ "$1" == "keep"  ]] || rm -rf miui-*/
for i in "${eu_urls[@]}"
do
   bash cleaner-fix.sh "$i" || exit 1
done
exit 0
