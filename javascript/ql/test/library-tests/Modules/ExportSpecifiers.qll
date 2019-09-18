import semmle.javascript.ES2015Modules

query predicate test_ExportSpecifiers(ExportSpecifier es, Identifier res0, Identifier res1) {
  res0 = es.getLocal() and res1 = es.getExported()
}
