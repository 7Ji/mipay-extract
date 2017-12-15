#!/bin/bash

declare -a urls=(

# Rom URLs
'http://bigota.d.miui.com/7.12.14/miui_MIMIX2_7.12.14_409c897172_7.1.zip'

)

EU_VER=7.12.14

declare -a eu_urls=(

# EU Rom URLs
"https://jaist.dl.sourceforge.net/project/xiaomi-eu-multilang-miui-roms/xiaomi.eu/MIUI-WEEKLY-RELEASES/${EU_VER}/xiaomi.eu_multi_MIMix2_${EU_VER}_v9-7.1.zip"

)

command -v dirname >/dev/null 2>&1 && cd "$(dirname "$0")"
if [[ "$1" == "rom" ]]; then
    base_dir=/sdcard/TWRP/rom
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
