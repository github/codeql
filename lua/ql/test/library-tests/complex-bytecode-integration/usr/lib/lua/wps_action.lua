#!/usr/bin/env lua
local dat_parser = require("l1dat_parser")
ifname = arg[1]

if (ifname ~= "") then

    zone_name = dat_parser.l1_ifname_to_zone(ifname)
    if (zone_name ~= "") then
        -- 2860 interface check
        if (string.find(zone_name,"dev1") ~= nil) then
            os.execute("killall -SIGXFSZ nvram_daemon")
        end

        -- RTDEV interface check
        if (string.find(zone_name,"dev2") ~= nil) then
            os.execute("killall -SIGWINCH nvram_daemon")
        end

        -- wifi3 interface check
        if (string.find(zone_name,"dev3") ~= nil) then
            os.execute("killall -SIGPWR nvram_daemon")
        end
    else
        print "unable to find zone name"
    end
end