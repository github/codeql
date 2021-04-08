import python

from ModuleValue mv, string usage
where
  // builtin module has different name in Python 2 and 3
  not mv = Module::builtinModule() and
  (
    mv.isUsedAsModule() and usage = "isUsedAsModule"
    or
    mv.isUsedAsScript() and usage = "isUsedAsScript"
    or
    not mv.isUsedAsModule() and
    not mv.isUsedAsScript() and
    usage = "<UNKNOWN>"
  )
select mv, usage
