import actions

from ReusableWorkflow callee, ExternalJob caller
where callee.getACaller() = caller
select caller, caller.getCallee(), callee.getLocation().getFile().getRelativePath()
