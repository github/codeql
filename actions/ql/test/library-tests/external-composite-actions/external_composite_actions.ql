import actions

string getVersion(UsesStep call) {
  result = call.getVersion()
  or
  not exists(call.getVersion()) and result = ""
}

from CompositeAction callee, UsesStep caller
where callee.getACallerStep() = caller
select caller, caller.getCallee(), getVersion(caller),
  callee.getLocation().getFile().getRelativePath()
