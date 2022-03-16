/**
 * @name Large 'maxRequestLength' value
 * @description Setting a large 'maxRequestLength' value may render a webpage vulnerable to
 *              denial-of-service attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @id cs/web/large-max-request-length
 * @tags security
 *       frameworks/asp.net
 *       external/cwe/cwe-16
 */

import csharp
import semmle.code.asp.WebConfig

from SystemWebXmlElement web, XMLAttribute maxReqLength
where
  maxReqLength =
    web.getAChild(any(string s | s.toLowerCase() = "httpruntime"))
        .getAttribute(any(string s | s.toLowerCase() = "maxrequestlength")) and
  maxReqLength.getValue().toInt() > 4096
select maxReqLength, "Large 'maxRequestLength' value (" + maxReqLength.getValue() + " KB)."
