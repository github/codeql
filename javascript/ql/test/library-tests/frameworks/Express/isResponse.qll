import semmle.javascript.frameworks.Express

query predicate test_isResponse(Expr nd) { Express::isResponse(nd) }
