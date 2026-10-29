import javascript

query string getModuleType(TopLevel top) {
  not top.isExterns() and
  (
    not top instanceof Module and
    result = "non-module"
    or
    top instanceof NodeModule and
    result = "node"
    or
    top instanceof ES2015Module and
    result = "es2015"
    or
    top instanceof AmdModule and
    result = "amd"
  )
}
