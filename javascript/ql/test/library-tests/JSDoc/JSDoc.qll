import semmle.javascript.JSDoc

query predicate test_JSDoc(JSDoc jsdoc, string res0, Comment res1) {
  res0 = jsdoc.getDescription() and res1 = jsdoc.getComment()
}
