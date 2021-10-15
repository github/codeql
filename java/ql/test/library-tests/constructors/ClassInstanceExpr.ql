import default

// There should just be one class instance expr
from ClassInstanceExpr expr
where expr.getCompilationUnit().getPackage().hasName("constructors")
select expr
