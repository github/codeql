local luci  = {}
luci.util = require "luci.util"
luci.http = require "luci.http"
local uci = require "luci.model.uci"

module("luci.controller.ipsec", package.seeall)

function index()
        entry({"admin", "network", "ipsec"}, cbi("ipsec"), _("IP Security"))
        entry({"admin", "network", "ipsec", "vpn_status"}, call("ipsec_vpn_status"), nil).leaf = true
        entry({"admin", "network", "ipsec", "vpn_connect"}, call("ipsec_vpn_connect"), nil).leaf = true
        entry({"admin", "network", "ipsec", "vpn_disconnect"}, call("ipsec_vpn_disconnect"), nil).leaf = true
end

function ipsec_vpn_status()
    local handle = io.popen(" ipsec status  2>/dev/null")
    local result = handle:read("*all")
    handle:close()
    local obj ={}

    luci.http.prepare_content("application/json")
    if result == "" then
        obj.status = "Disconnected"
        obj.msg = "Disconnected/Command not found"
        luci.http.write_json(obj)
        return
    end

    a = string.match(result, "(%d+) up")
    if (tonumber(a) == 0) then
        b = string.match(result, "(%d) connecting")
        if (tonumber(b) == 0) then
            obj.status = "Disconnected"
            obj.msg = "Disconnected"
            luci.http.write_json(obj)
            return
        end
        obj.status = "Connected"
        obj.msg =  b.." connecting"
        luci.http.write_json(obj)
        return
    end
    for line in result:gmatch("([^\n]*)\n?") do
        if (string.find(line, "ESTABLISHED") or string.find(line, "DELETING")) then
                obj.status = "Connected"
                obj.msg = string.match(line, ": (.*),")
                luci.http.write_json(obj)
        end
    end
end

function ipsec_vpn_connect()
        local l_gw_name = ""
        local curs = uci.cursor()
        curs:foreach("ipsec", "remote", function(s) l_gw_name = s[".name"] end)
        l_subnet = curs:get("ipsec", "TUNNEL", "local_subnet")
        l_wan    = curs:get("network","wan" ,"device")

        luci.util.execi("iptables -t nat -I POSTROUTING -o "..l_wan.." -s "..l_subnet.." -j ACCEPT")
        luci.util.execi("ipsec down "..l_gw_name.."-TUNNEL")
        luci.util.execi("ipsec up "..l_gw_name.."-TUNNEL")
        ipsec_vpn_status()
end

function ipsec_vpn_disconnect()
        local l_gw_name = ""
        local curs = uci.cursor()
        curs:foreach("ipsec", "remote", function(s) l_gw_name = s[".name"] end)

        luci.util.execi("ipsec down "..l_gw_name.."-TUNNEL")
        ipsec_vpn_status()
end
