import semmle.javascript.Closure

from GoogFunctionCall gfc
select gfc, gfc.getFunctionName()