import semmle.javascript.Externs

from ExternalDecl ed
select ed, ed.getQualifiedName()
