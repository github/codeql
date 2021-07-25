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

from Expr cookieExpr, False f, None n
where
  exists(HeaderDeclaration headerWrite, StrConst headerName, StrConst headerValue |
    headerName.getText() = "Set-Cookie" and
    DataFlow::exprNode(headerName).(DataFlow::LocalSourceNode).flowsTo(headerWrite.getNameArg()) and
    not headerValue.getText().regexpMatch(".*; *Secure;.*") and
    DataFlow::exprNode(headerValue).(DataFlow::LocalSourceNode).flowsTo(headerWrite.getValueArg()) and
    cookieExpr = headerWrite.asExpr()
  )
  or
  exists(ExperimentalHTTP::CookieWrite cookieWrite |
    [DataFlow::exprNode(f), DataFlow::exprNode(n)]
        .(DataFlow::LocalSourceNode)
        .flowsTo(cookieWrite.(DataFlow::CallCfgNode).getArgByName("secure")) and
    cookieExpr = cookieWrite.asExpr()
  )
select cookieExpr, "Cookie is added to response without the 'secure' flag being set."
