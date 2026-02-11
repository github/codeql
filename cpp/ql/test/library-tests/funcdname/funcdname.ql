import cpp

from Function f, ReturnStmt r
where r.getEnclosingFunction() = f
select f.getQualifiedName(),
  r.getExpr()
      .getValue()
      .regexpReplaceAll("_[0-9a-f]+AEv$", "_?AEv")
      .regexpReplaceAll("cpp_[0-9a-f]+Foo37_", "cpp_?Foo37_")
