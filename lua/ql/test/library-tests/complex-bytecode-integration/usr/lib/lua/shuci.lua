#!/usr/bin/env lua

--[[
 * A pure lua library to translate between lua table and uci config
 *
 * For UCI: http://wiki.openwrt.org/doc/techref/uci
 *          http://wiki.openwrt.org/doc/uci
 *
 * Copyright (C) 2015 Hua Shao <nossiac@163.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License version 2.1
 * as published by the Free Software Foundation
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
]]


local shuci = {}

function shuci.decode(path)
    function file_exists(name)
        if not name then return false end
        local f = io.open(name,"r")
        if f then io.close(f) return true else return false end
    end
    local function linebreaker(str)
        local i,_ = string.find(str, "([^%s])")
        if not i then return nil end
        if string.find(str, "config%s+%w+") then
            local i,j,k,v = string.find(str, "config%s+([%w-_]+)%s*['\"]*([^%s\'\"]*)")
            return "section", k, v
        elseif string.find(str, "option%s+%w+") then
            local i,j,k,v = string.find(str, "option%s+([%w-_]+)%s*['\"]([^'\"]+)['\"]")
            if not k or not v then
                i,j,k,v = string.find(str, "option%s+([%w-_]+)%s*['\"]*([^%s\'\"]*)")
            end
            return "option", k, v
        elseif string.find(str, "list%s+%w+") then
            local i,j,k,v = string.find(str, "list%s+([%w-_]+)%s*['\"]([^'\"]+)['\"]")
            if not k or not v then
                i,j,k,v = string.find(str, "list%s+([%w-_]+)%s*['\"]*([^%s\'\"]*)")
            end
            return "list", k, v
        else
            print("invalid line!", str)
            return nil
        end
    end

    if not file_exists(path) then
        return
    end

    local _sect_ = nil
    local t = {}
    for line in io.lines(path) do
        local _type, _name, _value = linebreaker(line)
        if _type == "section" then
            if not t[_name] then t[_name] = {} end
            -- be careful of anonymous sections
            if not _value or _value == "" then _value = #t[_name]+1 end
            t[_name][_value] = {}
            _sect_ = t[_name][_value]
        end
        if _type == "option" then
            if _name and _value then
                _sect_[_name] = _value
            end
        end
        if _type == "list" and _name and _value then
            local idx
            if not _sect_[_name] then
                _sect_[_name] = {}
                _sect_[_name][1] = _value
            else
                idx = #_sect_[_name]
                _sect_[_name][idx+1] = _value
            end
        end
    end

    return t
end


function shuci.encode(t, path)
    local dump = io.write
    if path then
        local fp = io.open(path, "a+")
        dump = function(str) fp:write(str) end
    end
    for _sect_type,_ in pairs(t) do
        for _name,_sect in pairs(t[_sect_type]) do
            dump(string.format("config\t%s\t'%s'\n", _sect_type, _name))
            for k,v in pairs(_sect) do
                if type(v) == "table" then
                    for _,vv in ipairs(v) do
                        dump(string.format("\tlist\t%s\t'%s'\n",k,vv))
                    end
                elseif type(v) == "string" and k ~= ".name" then
                    dump(string.format("\toption\t%s\t'%s'\n",k,v))
                elseif type(v) == "number" and k ~= ".name" then
                    dump(string.format("\toption\t%s\t'%s'\n",k,tonumber(v)))
                end
            end
        dump("\n")
        end
    end
end


function shuci.dump(t, indent)
    if not indent then indent = 0 end
    for k,v in pairs(t) do
        if type(v) == "table" then
            print(string.rep(" ",indent)..k..":")
            shuci.dump(v, indent+4)
        else
            print(string.rep(" ",indent)..k..":"..v)
        end
    end
end

return shuci
