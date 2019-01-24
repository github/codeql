import javascript

string getTarget(InvokeExpr e) {
  result = e.getResolvedCallee().toString()
  or
  not exists(e.getResolvedCallee()) and
  result = "no concrete target"
}

from InvokeExpr invoke
select invoke, invoke.getResolvedCalleeName(), getTarget(invoke)
