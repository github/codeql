import java

from Stmt s
select s, s.getPrimaryQlClasses()

query predicate enclosing(Stmt s, Stmt encl) { s.getEnclosingStmt() = encl }
