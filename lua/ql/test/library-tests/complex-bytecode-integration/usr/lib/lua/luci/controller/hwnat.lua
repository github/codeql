-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2008 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.
local luci  = {}
luci.util = require "luci.util"
luci.http = require "luci.http"

module("luci.controller.hwnat", package.seeall)
function read_pipe(pipe)
    local fp = io.popen(pipe)
    local txt =  fp:read("*a")
    fp:close()
    return txt
end

function index()
	if not (nixio.fs.access("/etc/config/hwnat") or nixio.fs.access("/etc/config/hwnat")) then
		return
	end

	entry({"admin", "mtk", "hwnat"}, cbi("hwnat"), _("NAT Accelerate"))
	entry({"admin", "mtk", "hwnat_binding_status"}, call("hwnat_binding_status"), nil).leaf = true
end

function hwnat_binding_status()
	local result = luci.util.execi("hwnat -g")
    local data = {}
    local t = {}
    local proto_num = {}
    local i = 0

	luci.http.prepare_content("application/json")

    if not result then
        luci.http.write('[]')
        return
    end

    for line in result do
        if i ~= 0 and line:match(":") then
            t = line:split(" ")
            proto_num = t[1]:split("=")
            data[#data+1] = {
                type_ = proto_num[1],
                foe_entry = proto_num[2],
                src_info = t[3],
                new_info = t[5]
            }
        end
        i = i + 1
    end

    luci.http.write_json(data)
end