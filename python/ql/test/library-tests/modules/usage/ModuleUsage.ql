import python

from ModuleValue mv, string usage
where
    mv.isUsedAsModule() and usage = "isUsedAsModule"
    or
    mv.isUsedAsScript() and usage = "isUsedAsScript"
    or
    not mv.isUsedAsModule() and
    not mv.isUsedAsScript() and
    usage = "<UNKNOWN>"
select mv, usage
