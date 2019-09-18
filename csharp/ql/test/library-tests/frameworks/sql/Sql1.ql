import semmle.code.csharp.frameworks.Sql

from SqlExpr se
select se, se.getSql()
