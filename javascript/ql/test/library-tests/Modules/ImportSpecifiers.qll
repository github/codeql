import semmle.javascript.ES2015Modules

query predicate test_ImportSpecifiers(ImportSpecifier is, VarDecl res) { res = is.getLocal() }
