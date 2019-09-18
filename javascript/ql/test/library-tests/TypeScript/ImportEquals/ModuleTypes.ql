import javascript

string getModuleType(TopLevel top) {
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
}

from TopLevel top
where not top.isExterns()
select top.getFile().getBaseName(), getModuleType(top)
