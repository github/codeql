#!/usr/bin/env lua
--This file is created for check some deamons like miniupnpd,8021xd...

function __trim(s)
  if s then return (s:gsub("^%s*(.-)%s*$", "%1")) end
end

function exists(path)
    local fp = io.open(path, "rb")
    if fp then fp:close() end
    return fp ~= nil
end

function load_profile(path)
    local cfgs = {}
    local fd = io.open(path, "r")
    if not fd then return cfgs end

    for line in fd:lines() do
        line = __trim(line)
        if string.byte(line) ~= string.byte("#") then
            local i = string.find(line, "=")
            if i then
                local k,v
                k = string.sub(line, 1, i-1)
                v = string.sub(line, i+1)
                -- if cfgs[__trim(k)] then
                --     print("warning", "skip repeated key"..line)
                -- end
                cfgs[__trim(k)] = __trim(v) or ""
            -- else
            --     print("warning", "skip line without '=' "..line)
            end
        -- else
        --     print("warning", "skip comment line "..line)
        end
    end
    fd:close()
    return cfgs
end

function d8021xd_chk(profile,prefix,main_ifname,enable)
    local cfgs = load_profile(profile)
    local auth_mode = cfgs.AuthMode
    local ieee8021x = cfgs.IEEE8021X
    local pat_auth_mode = {"WPA$", "WPA;", "WPA2$", "WPA2;", "WPA1WPA2$", "WPA1WPA2;"}
    local pat_ieee8021x = {"1$", "1;"}
    local apd_en = false
    if exists("/tmp/run/8021xd_"..main_ifname..".pid") then
        os.execute("cat /tmp/run/8021xd_"..main_ifname..".pid | xargs kill -9")
        os.execute("rm /tmp/run/8021xd_"..main_ifname..".pid")
    end
    if enable == "true" then
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
            os.execute("8021xd -p "..prefix.. " -i "..main_ifname)
        end
    end
end

-- wifi service that require to start after wifi up
function wifi_service_misc()
    -- 1.Wapp
    if exists("/usr/bin/wapp_openwrt.sh") then
        os.execute("/usr/bin/wapp_openwrt.sh")
    end

    -- 2.EasyMesh
    if exists("/usr/bin/EasyMesh_openwrt.sh") then
        os.execute("/usr/bin/EasyMesh_openwrt.sh")
    end
end

service = arg[1]

if service == "s8021x" then
    d8021xd_chk(arg[2], arg[3], arg[4], arg[5])
elseif service == "wifi_service_misc" then
    wifi_service_misc()
end
