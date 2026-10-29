import semmle.code.java.Expr

from StringLiteral lit, string isTextBlock
where
  lit.getFile().(CompilationUnit).fromSource() and
  if lit.isTextBlock() then isTextBlock = "text-block" else isTextBlock = ""
select lit, lit.getValue(), isTextBlock
