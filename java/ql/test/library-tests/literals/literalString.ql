import semmle.code.java.Expr

from StringLiteral lit
where lit.getFile().(CompilationUnit).fromSource()
select lit
