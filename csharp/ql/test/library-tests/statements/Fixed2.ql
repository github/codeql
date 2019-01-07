import csharp

from FixedStmt fixed, LocalVariableDeclExpr decl
where decl = fixed.getAVariableDeclExpr()
select fixed, decl, decl.getVariable(), decl.getInitializer()
