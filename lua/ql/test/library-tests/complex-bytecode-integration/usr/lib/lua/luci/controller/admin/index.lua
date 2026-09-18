-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.admin.index", package.seeall)

function action_logout()
	local dsp = require "luci.dispatcher"
	local utl = require "luci.util"
	local sid = dsp.context.authsession

	if sid then
		utl.ubus("session", "destroy", { ubus_rpc_session = sid })

		luci.http.header("Set-Cookie", "sysauth=%s; expires=%s; path=%s" %{
			'', 'Thu, 01 Jan 1970 01:00:00 GMT', dsp.build_url()
		})
	end

	luci.http.redirect(dsp.build_url())
end

function action_translations(lang)
	local i18n = require "luci.i18n"
	local http = require "luci.http"
	local fs = require "nixio".fs

	if lang and #lang > 0 then
		lang = i18n.setlanguage(lang)
		if lang then
			local s = fs.stat("%s/base.%s.lmo" %{ i18n.i18ndir, lang })
			if s then
				http.header("Cache-Control", "public, max-age=31536000")
				http.header("ETag", "%x-%x-%x" %{ s["ino"], s["size"], s["mtime"] })
			end
		end
	end

	http.prepare_content("application/javascript; charset=utf-8")
	http.write("window.TR=")
	http.write_json(i18n.dump())
end

local function ubus_reply(id, data, code, errmsg)
	local reply = { jsonrpc = "2.0", id = id }
	if errmsg then
		reply.error = {
			code = code,
			message = errmsg
		}
	elseif type(code) == "table" then
		reply.result = code
	else
		reply.result = { code, data }
	end

	return reply
end

local ubus_types = {
	nil,
	"array",
	"object",
	"string",
	nil, -- INT64
	"number",
	nil, -- INT16,
	"boolean",
	"double"
}

local function ubus_access(sid, obj, fun)
	local res, code = luci.util.ubus("session", "access", {
		ubus_rpc_session = sid,
		scope            = "ubus",
		object           = obj,
		["function"]     = fun
	})

	return (type(res) == "table" and res.access == true)
end

local function ubus_request(req)
	if type(req) ~= "table" or type(req.method) ~= "string" or req.jsonrpc ~= "2.0" or req.id == nil then
		return ubus_reply(nil, nil, -32600, "Invalid request")

	elseif req.method == "call" then
		if type(req.params) ~= "table" or #req.params < 3 then
			return ubus_reply(nil, nil, -32600, "Invalid parameters")
		end

		local sid, obj, fun, arg =
			req.params[1], req.params[2], req.params[3], req.params[4] or {}
		if type(arg) ~= "table" or arg.ubus_rpc_session ~= nil then
			return ubus_reply(req.id, nil, -32602, "Invalid parameters")
		end

		if sid == "00000000000000000000000000000000" and luci.dispatcher.context.authsession then
			sid = luci.dispatcher.context.authsession
		end

		if not ubus_access(sid, obj, fun) then
			return ubus_reply(req.id, nil, -32002, "Access denied")
		end

		arg.ubus_rpc_session = sid

		local res, code = luci.util.ubus(obj, fun, arg)
		return ubus_reply(req.id, res, code or 0)

	elseif req.method == "list" then
		if req.params == nil or (type(req.params) == "table" and #req.params == 0) then
			local objs = luci.util.ubus()
			return ubus_reply(req.id, nil, objs)

		elseif type(req.params) == "table" then
			local n, rv = nil, {}
			for n = 1, #req.params do
				if type(req.params[n]) ~= "string" then
					return ubus_reply(req.id, nil, -32602, "Invalid parameters")
				end

				local sig = luci.util.ubus(req.params[n])
				if sig and type(sig) == "table" then
					rv[req.params[n]] = {}

					local m, p
					for m, p in pairs(sig) do
						if type(p) == "table" then
							rv[req.params[n]][m] = {}

							local pn, pt
							for pn, pt in pairs(p) do
								rv[req.params[n]][m][pn] = ubus_types[pt] or "unknown"
							end
						end
					end
				end
			end
			return ubus_reply(req.id, nil, rv)

		else
			return ubus_reply(req.id, nil, -32602, "Invalid parameters")
		end
	end

	return ubus_reply(req.id, nil, -32601, "Method not found")
end

function action_ubus()
	local parser = require "luci.jsonc".new()

	luci.http.context.request:setfilehandler(function(_, s)
		if not s then
			return nil
		end

		local ok, err = parser:parse(s)
		return (not err or nil)
	end)

	luci.http.context.request:content()

	local json = parser:get()
	if json == nil or type(json) ~= "table" then
		luci.http.prepare_content("application/json")
		luci.http.write_json(ubus_reply(nil, nil, -32700, "Parse error"))
		return
	end

	local response
	if #json == 0 then
		response = ubus_request(json)
	else
		response = {}

		local _, request
		for _, request in ipairs(json) do
			response[_] = ubus_request(request)
		end
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json(response)
end

function action_menu()
	local dsp = require "luci.dispatcher"
	local utl = require "luci.util"
	local http = require "luci.http"

	local acls = utl.ubus("session", "access", { ubus_rpc_session = http.getcookie("sysauth") })
	local menu = dsp.menu_json(acls or {}) or {}

	http.prepare_content("application/json")
	http.write_json(menu)
end
