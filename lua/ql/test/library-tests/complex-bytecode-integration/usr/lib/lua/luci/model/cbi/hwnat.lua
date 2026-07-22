
m = Map("hwnat", translate("Hardware NAT Acceleration"),
	translate("The <em>Hardware NAT Acceleration designed for reducing cpu loading"))

s = m:section(TypedSection, "hwnat", "HWNAT")
s.addremove=false
s.anonymous = true
enable = s:option(Flag,"enabled",translate("Enable"))

m:section(SimpleSection).template = "admin_mtk/hwnat_status"

return m