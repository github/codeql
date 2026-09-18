local host = luci.http.formvalue("host")
local safe_host = shellquote(host)

os.execute("ping -c 1 " .. safe_host)
