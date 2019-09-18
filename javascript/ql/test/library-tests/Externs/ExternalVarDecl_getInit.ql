import semmle.javascript.Externs

from ExternalVarDecl ed
select ed, ed.getInit()
