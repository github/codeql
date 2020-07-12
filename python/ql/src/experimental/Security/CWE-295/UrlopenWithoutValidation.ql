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

from
  FunctionValue urlopen, CallNode call, ControlFlowNode http_arg, StringValue http_string,
  Value empty
where
  urlopen = Value::named(["urllib2.request.urlopen", "urllib.request.urlopen"]) and
  http_arg = urlopen.getArgumentForCall(call, 0) and
  http_arg.pointsTo(http_string) and
  http_string.getText().matches("https://%") and
  (
    not exists(Value verify |
      verify = call.getArgByName(["cafile", "capath", "context"]).pointsTo()
    )
    or
    empty = call.getArgByName(["cafile", "capath", "context"]).pointsTo() and
    empty = Value::none_()
  )
select call, "This call to urlopen does not provide any certificate validation"
