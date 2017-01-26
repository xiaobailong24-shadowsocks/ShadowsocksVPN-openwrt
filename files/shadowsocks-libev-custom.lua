local fs = require "nixio.fs"
local conffile = "/etc/shadowsocks/shadowsocks_custom.conf" 

f = SimpleForm("custom", translate("Shadowsocks - Custom List"), translate("This is the custom list file for Shadowsocks."))

t = f:field(TextValue, "conf")
t.rmempty = true
t.rows = 20
function t.cfgvalue()
	return fs.readfile(conffile) or ""
end

function f.handle(self, state, data)
	if state == FORM_VALID then
		if data.conf then
			fs.writefile(conffile, data.conf:gsub("\r\n", "\n"))
			luci.sys.call("/etc/init.d/shadowsocks restart && ipset flush gfwlist")
		end
	end
	return true
end

return f
