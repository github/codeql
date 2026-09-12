-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

local tparser = require "luci.template.parser"
local string = require "string"

local tostring = tostring

module "luci.xml"

--
-- String and data manipulation routines
--

function pcdata(value)
	return value and tparser.pcdata(tostring(value))
end

function striptags(value)
	return value and tparser.striptags(tostring(value))
end


-- also register functions above in the central string class for convenience
string.pcdata      = pcdata
string.striptags   = striptags
