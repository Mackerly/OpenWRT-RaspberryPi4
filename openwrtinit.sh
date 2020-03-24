#!/bin/sh
# openwrt uci-default
# by 咖啡小冰 QQ:857305001

# set somethings
uci set network.lan.ipaddr='192.168.1.1'

uci set system.@system[0].zonename='Asia/Shanghai'
uci set system.@system[0].timezone='CST-8'

uci set luci.main.lang=zh_cn

uci commit

mkdir -p ./files/etc/hotplug.d/block
# samba autoshare
wget -O ./files/etc/hotplug.d/block/20-smb https://github.com/Mackerly/OpenWRT-RaspberryPi4/raw/master/20-smb

# blockdevice automount
wget -O ./files/etc/hotplug.d/block/11-mount https://github.com/Mackerly/OpenWRT-RaspberryPi4/raw/master/11-mount

# add some alias to profile
cat >> /etc/profile <<EOF
alias df='df -Th'
alias free='free -m'
alias la='ll -A'
alias ll='ls -alh --color=auto'
alias ls='ls --color=auto'
export PS1='[\[\033[35;1m\]\u\[\033[0m\]@\[\033[31;1m\]\h\[\033\[0m\]:\[\033[32;1m\]$PWD\[\033[0m\]]\$ '
EOF

# raspberry 5G wifi access point
cat << EOF > /etc/config/wireless
wireless.radio0=wifi-device
wireless.radio0.type='mac80211'
wireless.radio0.channel='36'
wireless.radio0.hwmode='11a'
wireless.radio0.path='platform/soc/fe300000.mmcnr/mmc_host/mmc1/mmc1:0001/mmc1:0001:1'
wireless.radio0.legacy_rates='0'
wireless.radio0.country='US'
wireless.radio0.htmode='VHT20'
wireless.radio0.disabled='0'
wireless.default_radio0=wifi-iface
wireless.default_radio0.device='radio0'
wireless.default_radio0.network='lan'
wireless.default_radio0.mode='ap'
wireless.default_radio0.ssid='Raspberry-5G'
EOF

# wait 40 seconds,then reboot
sleep 40
reboot