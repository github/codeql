import semmle.javascript.frameworks.Express

query predicate test_isRequest(Expr nd) { Express::isRequest(nd) }
