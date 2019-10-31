/**
 * @name Large 'maxRequestLength' value
 * @description Setting a large 'maxRequestLength' value may render a web page vulnerable to
 *              denial-of-service attacks.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/web/large-max-request-length
 * @tags security
 *       frameworks/asp.net
 *       external/cwe/cwe-16
 */

import csharp
import semmle.code.asp.WebConfig

from SystemWebXMLElement web, XMLAttribute a
where
  a = web
        .getAChild(any(string s | s.toLowerCase() = "httpruntime"))
        .getAttribute(any(string s | s.toLowerCase() = "maxrequestlength")) and
  a.getValue().toInt() > 4096
select a, "Large 'maxRequestLength' value (" + a.getValue() + ")."
