import codeql_ql.printAst

predicate foobar() {
  // this exists to test the printAst query
  exists(int i | i = [1 .. 100] | i * 3 = i + 2)
}
