#echo -e "Select Platform\n 1): arm32-v7a\n 2): arm64-v8a\n"
#read -p ":" platfrom
platfrom=2
echo "- Connect official V2Ray download link."
baseLink=$(curl -s https://github.com/v2ray/v2ray-core/releases/latest | grep -Eo "https://.*v[0-9]+.[0-9]+.[0-9]+" | sed "s/tag/download/g")

case $platfrom in
   "1")
    curl "${baseLink}/v2ray-linux-arm32-v7a.zip" -k -L -o "v2ray-core.zip" >&2
    if [ "$?" != "0" ] ; then
        ui_print "Error: Download V2Ray core failed."
        exit 1
    fi
    ;;
   "2")
    curl "${baseLink}/v2ray-linux-arm64-v8a.zip" -k -L -o "v2ray-core.zip" >&2
    if [ "$?" != "0" ] ; then
        ui_print "Error: Download V2Ray core failed."
        exit 1
    fi
    ;;
   *)
    Not found
    ;;
esac

echo "- Fetch Newest v2ray-rules-dat"
rulesBaselink=$(curl -s https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest | grep -Eo "https://.*/tag/[0-9]+" | sed "s/tag/download/g")
curl "${rulesBaselink}/geoip.dat" -k -L -o geoip.dat >&2
if [ "$?" != "0" ] ; then
    ui_print "Error: Download geoip.dat failed."
    exit 1
fi
curl "${rulesBaselink}/geosite.dat" -k -L -o geosite.dat >&2
if [ "$?" != "0" ] ; then
    ui_print "Error: Download geoip.dat failed."
    exit 1
fi

echo "- Remake v2ray-core.zip"
zip -u v2ray-core.zip geosite.dat geosite.dat >&2
if [ "$?" != "0" ] ; then
    ui_print "Error: remake v2ray-core.zip failed."
    exit 1
fi
zip -u v2ray-core.zip geoip.dat geoip.dat >&2
if [ "$?" != "0" ] ; then
    ui_print "Error: remake v2ray-core.zip failed."
    exit 1
fi

echo "- Make v2ray-magisk.zip" 
zip -r9 v2ray-magisk.zip * -x .git geosite.dat geoip.dat

rm -f geosite.dat
rm -f geoip.dat
rm -f v2ray-core.zip
