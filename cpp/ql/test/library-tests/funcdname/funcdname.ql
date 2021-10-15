import cpp

from Function f, ReturnStmt r
where r.getEnclosingFunction() = f
select f.getQualifiedName(), r.getExpr().getValue().regexpReplaceAll("_[0-9a-f]+AEv$", "_?AEv")
