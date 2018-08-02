import semmle.code.cil.ConsistencyChecks

from MissingCilDeclaration v
select v, v.getMessage()
