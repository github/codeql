import csharp
import semmle.code.csharp.frameworks.Sql

from SqlExpr e
where not e.getFile().getAbsolutePath().contains("/resources/stubs/")
select e
