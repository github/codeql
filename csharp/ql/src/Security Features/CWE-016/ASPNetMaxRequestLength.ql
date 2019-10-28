/**
 * @name Large maxRequestLength value
 * @description maxRequestLength should be set as minimum as possible.
 * @kind problem
 * @problem.severity warning
 * @id cs/web/max-request-length
 * @tags security
 *       maintainability
 *       frameworks/asp.net
 *       external/cwe/cwe-16
 */

import csharp
from XMLAttribute a
where
  a.getName().toLowerCase() = "maxrequestlength" and a.getValue().toInt() > 4096
select a, "Large 'maxRequestLength' value (" + a.getValue() + ")."
