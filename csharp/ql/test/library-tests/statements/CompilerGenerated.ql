import csharp

from Stmt stmt
where stmt.isCompilerGenerated()
select stmt, stmt.getEnclosingCallable()
