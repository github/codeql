require "luci.model.uci"
require "luci.sys"
local sec_name
local cursor = luci.model.uci.cursor()
cursor:foreach("ipsec", "remote", function(s) sec_name = s['.name'] end)
m = Map("ipsec", translate("IP Security"))

s = m:section(TypedSection, "remote")
s.anonymous = true
o=s:option(Value, "localGatewayName", translate("Local Gateway Name"))
o.default = sec_name

o=s:option(ListValue, "enabled", translate("IPSec VPN"))
o.widget="radio"
o.orientation = "horizontal"
o:value("0", "Disable") -- Key and value pairs
o:value("1", "Enable")

tunnel = m:section(NamedSection, "TUNNEL")
o=tunnel:option(Value, "local_subnet", translate("Local Group Subnet"))
o.rmempty= false
o.datatype = 'ip4addr'

s = m:section(TypedSection, "remote")
s.anonymous = true
o=s:option(Value, "gateway", translate("Remote Gateway IP Address"))
o.rmempty= false
o.datatype = 'ip4addr'

tunnel = m:section(NamedSection, "TUNNEL")
o=tunnel:option(Value, "remote_subnet", translate("Remote Group Subnet"))
o.rmempty= false
o.datatype = 'ip4addr'

s = m:section(TypedSection, "remote")
s.anonymous = true
p = s:option(ListValue, "authentication_method",translate"Keying Mode")
p:value("psk", "PSK")

o=s:option(Value, "pre_shared_key", translate("Pre-shared Key"))
o.rmempty= false

tunnel = m:section(NamedSection, "TUNNEL")
x = tunnel:option(ListValue, "mode",translate"Auto Mode")
x:value("add", "Add")
x:value("route", "Route")
x:value("start", "Start")
x:value("ignore", "Ignore")


d = tunnel:option(ListValue, "keyexchange",translate"Key Exchange")
d:value("ikev2", "ikev2")
d.default = "ikev2"

c = tunnel:option(Value, "ikelifetime",translate"IKE Lifetime")
c.default = "10800"

e = tunnel:option(Value, "lifetime",translate"Key Lifetime")
e.default = "3600"

z = m:section(NamedSection, "phase_1_settings", "crypto_proposal", "Phase 1 Settings")
z.addremove = false

q = z:option(ListValue, "encryption_algorithm",translate"Encryption")
q:value("aes128", "AES128")
q:value("aes192", "AES192")
q:value("aes256", "AES256")
q.default = "aes128"

w = z:option(ListValue, "hash_algorithm",translate"Authentication")
w:value("sha1", "SHA1")
w:value("sha256", "SHA256")
w.default = "sha1"

r = z:option(ListValue, "dh_group",translate"Group")
r:value("modp768", "modp768")
r:value("modp1024", "modp1024")
r:value("modp1536", "modp1536")
r.default = "modp768"

j = m:section(NamedSection, "phase_2_settings", "crypto_proposal", "Phase 2 Settings")
l = j:option(ListValue, "encryption_algorithm",translate"Encryption")
l:value("aes128", "AES128")
l:value("aes192", "AES192")
l:value("aes256", "AES256")
l.default = "aes128"

t = j:option(ListValue, "hash_algorithm",translate"Authentication")
t:value("sha1", "SHA1")
t:value("sha256", "SHA256")
t.default = "sha1"

u = j:option(ListValue, "dh_group",translate"Group")
u:value("modp768", "modp768")
u:value("modp1024", "modp1024")
u:value("modp1536", "modp1536")
u.default = "modp768"

con = m:section(TypedSection, "remote")
con.anonymous = true
status = con:option(Value, "vpn_status", translate"Status")
status.default = "Disconnected/Command not found"

function m.on_commit(Map)

	local cur = luci.model.uci.cursor()
	CBI_PREFIX = "cbid.ipsec."
	local org_sec_name,new_sec_name
	cur:foreach("ipsec", "remote", function(s) org_sec_name = s['.name'] end)

	local new_sec_name = luci.http.formvalue(CBI_PREFIX  ..org_sec_name.. ".localGatewayName")

	if(new_sec_name ~= org_sec_name) then
		--cur:rename('ipsec',org_sec_name,new_sec_name)
		cur:save('ipsec')
		cur:commit('ipsec')
	end
end

m:section(SimpleSection).template = "admin_mtk/mtk_ipsec_view"

return m
