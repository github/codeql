import csharp
import semmle.code.csharp.frameworks.Sql

from SqlExpr e
where not e.getFile().getAbsolutePath().matches("%/resources/stubs/%")
select e
