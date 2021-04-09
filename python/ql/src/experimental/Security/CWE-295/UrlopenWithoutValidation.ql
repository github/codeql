/**
 * @name Attempt to open url without certificate validation
 * @description Opening a url without certificate validation can allow man-in-the-middle attacks.
 * @kind problem
 * @problem.severity error
 * @id py/urlopen-without-cert-validation
 * @tags security
 *       external/cwe/cwe-295
 */

import python
import semmle.python.ApiGraphs

predicate calls_urllib(CallNode call) {
  call =
    API::moduleImport(["urllib", "urllib2"])
        .getMember("request")
        .getMember("urlopen")
        .getACall()
        .getNode()
}

predicate is_https(CallNode call) {
  exists(ControlFlowNode http_arg, StringValue http_string |
    http_arg = call.getArg(0) and
    http_arg.pointsTo(http_string) and
    http_string.getText().matches("https://%")
  )
}

predicate contains_capath(CallNode call) {
  not exists(ControlFlowNode verify | verify = call.getArgByName(["cafile", "capath", "context"]))
  or
  exists(ControlFlowNode empty |
    empty = call.getArgByName(["cafile", "capath", "context"]) and
    empty = API::builtin("None").getAnImmediateUse().asCfgNode()
  )
}

from CallNode call
where
  calls_urllib(call) and
  is_https(call) and
  contains_capath(call)
select call, "This call to urlopen does not provide any certificate validation"
