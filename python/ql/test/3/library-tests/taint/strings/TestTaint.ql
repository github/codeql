import python
import semmle.python.security.TaintTracking
import semmle.python.web.HttpRequest
import semmle.python.security.strings.Untrusted
import Taint

from
  Call call, Expr arg, boolean expected_taint, boolean has_taint, string test_res,
  string taint_string
where
  call.getLocation().getFile().getShortName() = "test.py" and
  (
    call.getFunc().(Name).getId() = "ensure_tainted" and
    expected_taint = true
    or
    call.getFunc().(Name).getId() = "ensure_not_tainted" and
    expected_taint = false
  ) and
  arg = call.getAnArg() and
  (
    not exists(TaintedNode tainted | tainted.getAstNode() = arg) and
    taint_string = "<NO TAINT>" and
    has_taint = false
    or
    exists(TaintedNode tainted | tainted.getAstNode() = arg |
      taint_string = tainted.getTaintKind().toString()
    ) and
    has_taint = true
  ) and
  if expected_taint = has_taint then test_res = "ok  " else test_res = "fail"
// if expected_taint = has_taint then test_res = "✓" else test_res = "✕"
select arg.getLocation().toString(), test_res, call.getScope().(Function).getName(), arg.toString(),
  taint_string
