import python
import semmle.python.dataflow.TaintTracking
import Taint

from Call call, Expr arg, string taint_string
where
  call.getLocation().getFile().getShortName() = "test.py" and
  call.getFunc().(Name).getId() = "test" and
  arg = call.getAnArg() and
  (
    not exists(TaintedNode tainted | tainted.getAstNode() = arg) and
    taint_string = "NO TAINT"
    or
    exists(TaintedNode tainted | tainted.getAstNode() = arg |
      taint_string = tainted.getTaintKind().toString()
    )
  )
select arg.getLocation().toString(), call.getScope().(Function).getName(), arg.toString(),
  taint_string
