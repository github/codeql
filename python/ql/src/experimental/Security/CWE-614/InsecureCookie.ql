/**
 * @name Failure to use secure cookies
 * @description Insecure cookies may be sent in cleartext, which makes them vulnerable to
 *              interception.
 * @kind problem
 * @problem.severity error
 * @id py/insecure-cookie
 * @tags security
 *       external/cwe/cwe-614
 */

// determine precision above
import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.Concepts
import experimental.semmle.python.Concepts

from HeaderDeclaration headerWrite, False f, None n
where
  exists(StrConst headerName, StrConst headerValue |
    headerName.getText() = "Set-Cookie" and
    DataFlow::exprNode(headerName).(DataFlow::LocalSourceNode).flowsTo(headerWrite.getNameArg()) and
    not headerValue.getText().regexpMatch(".*; *Secure;.*") and
    DataFlow::exprNode(headerValue).(DataFlow::LocalSourceNode).flowsTo(headerWrite.getValueArg())
  )
  or
  [DataFlow::exprNode(f), DataFlow::exprNode(n)]
      .(DataFlow::LocalSourceNode)
      .flowsTo(headerWrite.(DataFlow::CallCfgNode).getArgByName("secure"))
select headerWrite, "Cookie is added to response without the 'secure' flag being set."
