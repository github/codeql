--This file is created for check some deamons

    local mtkwifi = require("mtkwifi")
    local devs = mtkwifi.get_all_devs()
    local nixio = require("nixio")

function miniupnpd_chk(devname,vif,enable)
    local WAN_IF=mtkwifi.__trim(mtkwifi.read_pipe("uci -q get network.wan.ifname"))

    os.execute("rm -rf /etc/miniupnpd.conf")

    if mtkwifi.exists("/tmp/run/miniupnpd."..vif) then
        os.execute("cat /tmp/run/miniupnpd."..vif.." | xargs kill -9")
    end

    if enable then
        local profile = mtkwifi.search_dev_and_profile()[devname]
        local cfgs = mtkwifi.load_profile(profile)
        local ssid_index = devs[devname]["vifs"][vif].vifidx
        local wsc_conf_mode = ""
        local PORT_NUM = 7777+(string.byte(vif, -1)+string.byte(vif, -2))
        local LAN_IPADDR = mtkwifi.__trim(mtkwifi.read_pipe("uci -q get network.lan.ipaddr"))
        local LAN_MASK = mtkwifi.__trim(mtkwifi.read_pipe("uci -q get network.lan.netmask"))
        local port = 6352 + (string.byte(vif, -1)+string.byte(vif, -2))
        LAN_IPADDR = LAN_IPADDR.."/"..LAN_MASK
        wsc_conf_mode = mtkwifi.token_get(cfgs["WscConfMode"], ssid_index, "")

        local file = io.open("/etc/miniupnpd.conf", "w")
        if nil == file then
            nixio.syslog("debug","open file /etc/miniupnpd.conf fail")
        end

        file:write("ext_ifname=",WAN_IF,'\n','\n',
                   "listening_ip=",LAN_IPADDR,'\n','\n',
                   "port=",port,'\n','\n',
                   "bitrate_up=800000000",'\n',
                   "bitrate_down=800000000",'\n','\n',
                   "secure_mode=no",'\n','\n',
                   "system_uptime=yes",'\n','\n',
                   "notify_interval=30",'\n','\n',
                   "uuid=68555350-3352-3883-2883-335030522880",'\n','\n',
                   "serial=12345678",'\n','\n',
                   "model_number=1",'\n','\n',
                   "enable_upnp=no",'\n','\n')
        file:close()

        if wsc_conf_mode ~= "" and wsc_conf_mode ~= "0" then
            os.execute("miniupnpd -m 1 -I "..vif.." -P /var/run/miniupnpd."..vif.." -G -i "..WAN_IF.." -a "..LAN_IPADDR.." -n "..PORT_NUM)
        end
    end
end

function d8021xd_chk(devname, prefix, vif, enable)
    if mtkwifi.exists("/tmp/run/8021xd_"..vif..".pid") then
        os.execute("cat /tmp/run/8021xd_"..vif..".pid | xargs kill -9")
        os.execute("rm /tmp/run/8021xd_"..vif..".pid")
    end

    if enable then
        local profile = mtkwifi.search_dev_and_profile()[devname]
        local cfgs = mtkwifi.load_profile(profile)
        local auth_mode = cfgs.AuthMode
        local ieee8021x = cfgs.IEEE8021X
        local pat_auth_mode = {"WPA$", "WPA;", "WPA2$", "WPA2;", "WPA1WPA2$", "WPA1WPA2;", "WPA3$", "WPA3;", "192$", "192;", "WPA2-Ent-OSEN$", "WPA2-Ent-OSEN;"}
        local pat_ieee8021x = {"1$", "1;"}
        local apd_en = false

        for _, pat in ipairs(pat_auth_mode) do
            if string.find(auth_mode, pat) then
                apd_en = true
            end
        end

        for _, pat in ipairs(pat_ieee8021x) do
            if string.find(ieee8021x, pat) then
                apd_en = true
            end
        end

        if apd_en then
            os.execute("8021xd -p "..prefix.. " -i "..vif)
        end
    end
end

local function get_viflist()
    local devs = mtkwifi.get_all_devs()
    local vif_list = {}
    for _,dev in ipairs(devs) do
        for _,vif in ipairs(dev.vifs) do
            if not(string.find(dev.profile, "ax7800") and vif.vifname == "ra0") then
                table.insert(vif_list,vif.vifname)
            end
        end
    end
    return vif_list
end

-- wifi service that require to start after wifi up
function wifi_service_misc()
    local mapd_default = mtkwifi.load_profile("/etc/map/mapd_default.cfg")
    local mapd_user = mtkwifi.load_profile("/etc/map/mapd_user.cfg")
    local first_card_cfgs = mtkwifi.load_profile(mtkwifi.detect_first_card())

    local vif_list = get_viflist()
    local total_vif = #vif_list
    local over_time = 0
    while over_time < 30 do
        up_num = 0
        for _,vif in pairs(vif_list) do
            local is_up = string.find(mtkwifi.__trim(mtkwifi.read_pipe("ifconfig "..vif.." | grep UP")), "UP") ~= nil
            if is_up then
                up_num = up_num+1
            end
        end
        if up_num == total_vif then
            break
        else
            over_time = over_time + 1
            os.execute("sleep 1")
        end
    end

    if mapd_default.mode then
        local eth_mode = mapd_default.mode
        local device_role = mapd_default.DeviceRole
        if mapd_user.mode then
            eth_mode = mapd_user.mode
        end
        if mapd_user.DeviceRole then
            device_role = mapd_user.DeviceRole
        end
	-- Start Hostapd if exists
	if ((first_card_cfgs.MapMode == "1") and mtkwifi.exists("/usr/bin/hostapd")) then
	    os.execute("killall hostapd")
	    local hostapd_cmd = ""
	    for _,ifname in ipairs(string.split(mtkwifi.read_pipe("ls /sys/class/net"), "\n"))
	    do
	        if (string.match(ifname,"ra")) then
		    hostapd_cmd = hostapd_cmd.." /etc/hostapd_"..ifname.."_map.conf"
		end
	    end
	    print(hostapd_cmd)
	    os.execute("echo "..hostapd_cmd.." >/dev/console")
	    os.execute("/usr/bin/hostapd -B "..hostapd_cmd)
	end
        -- 1.Wapp
        if mtkwifi.exists("/usr/bin/wapp_openwrt.sh") then
            os.execute("./etc/init.d/wapp start")
        end
        -- 2.EasyMesh
        if mtkwifi.exists("/usr/bin/EasyMesh_openwrt.sh") then
            if first_card_cfgs.MapMode == "1" then
                if (eth_mode == "0" and device_role == "1") or eth_mode == "1" then
                    os.execute("./etc/init.d/easymesh start")
                else
                    os.execute("./etc/init.d/easymesh_bridge start")
                end
            else
                os.execute("./etc/init.d/easymesh start")
            end
        end
    else
        -- 1.Wapp
        if mtkwifi.exists("/usr/bin/wapp_openwrt.sh") then
            os.execute("./etc/init.d/wapp start")
        end
        -- 2.EasyMesh
        if mtkwifi.exists("/usr/bin/EasyMesh_openwrt.sh") then
            os.execute("./etc/init.d/easymesh start")
        end 
    end
    -- Start AFC
    os.execute("killall AFC")
    if mtkwifi.exists("/usr/bin/AFC") then
        local afc_cmd = "rax0 &"
        os.execute("echo start AFC in background > /dev/console")
        os.execute("/usr/bin/AFC "..afc_cmd)
    end
end

-- wifi service that require to clean up before wifi down
function wifi_service_misc_clean()
    os.execute("rm -rf /tmp/wapp_ctrl")
    os.execute("killall -15 mapd")
    os.execute("killall -15 wapp")
    os.execute("killall -15 p1905_managerd")
    os.execute("killall -15 bs20")
end
