import javascript

from Express::RouteSetup rs, boolean isUseCall
where if rs.isUseCall() then isUseCall = true else isUseCall = false
select rs, rs.getServer(), isUseCall
