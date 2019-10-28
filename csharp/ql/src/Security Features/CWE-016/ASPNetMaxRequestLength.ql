/**
 * @name Large maxRequestLength value
 * @description maxRequestLength should be set as minimum as possible.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cs/web/debug-binary
 * @tags security
 *       maintainability
 *       frameworks/asp.net
 *       external/cwe/cwe-16
 */

import csharp
from XMLAttribute a
where
  a.getName().toLowerCase() = "maxrequestlength" and a.getValue() > "4096"
select a, "maxRequestLength is set too large: "+a.getValue()+" KB. It is recommended to set it as minimum as possible based on business requirements."
