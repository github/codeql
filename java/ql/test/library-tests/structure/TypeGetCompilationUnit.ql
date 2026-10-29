import semmle.code.java.Type

predicate typeIsInCU(Type tpe, CompilationUnit cu) { tpe.getCompilationUnit() = cu }

from Type tpe, CompilationUnit aJava
where
  aJava.hasName("A") and
  typeIsInCU(tpe, aJava)
select tpe
