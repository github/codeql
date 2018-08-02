import cpp

from Element e, string type
where ((Function)e).isCompilerGenerated() and type = "Function"
   or ((Expr)    e).isCompilerGenerated() and type = "Expr"
   or ((Variable)e).isCompilerGenerated() and type = "Variable"
   or ((Stmt)    e).isCompilerGenerated() and type = "Stmt"
select e, type

