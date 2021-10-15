import semmle.code.java.Type

predicate typeIsInCU(Type tpe, CompilationUnit cu) { tpe.getCompilationUnit() = cu }

from Type tpe, CompilationUnit Ajava
where
  Ajava.hasName("A") and
  typeIsInCU(tpe, Ajava)
select tpe
