import cpp

from Element e, string type
where
  e.(Function).isCompilerGenerated() and type = "Function"
  or
  e.(Expr).isCompilerGenerated() and type = "Expr"
  or
  e.(Variable).isCompilerGenerated() and type = "Variable"
  or
  e.(Stmt).isCompilerGenerated() and type = "Stmt"
  or
  e.(Initializer).isCompilerGenerated() and type = "Initializer"
select e, type
