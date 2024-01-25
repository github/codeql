/**
 * @name Bypass Logical Validation Using Unicode Characters
 * @description A Unicode transformation is using a remote user-controlled data. The transformation is a Unicode normalization using the algorithms "NFC" or "NFKC". In all cases, the security measures implemented or the logical validation performed to escape any injection characters, to validate using regex patterns or to perform string-based checks, before the Unicode transformation are **bypassable** by special Unicode characters.
 * @kind path-problem
 * @id py/unicode-bypass-validation
 * @precision high
 * @problem.severity error
 * @tags security
 *       experimental
 *       external/cwe/cwe-176
 *       external/cwe/cwe-179
 *       external/cwe/cwe-180
 */

import python
import UnicodeBypassValidationQuery
import UnicodeBypassValidationFlow::PathGraph

from UnicodeBypassValidationFlow::PathNode source, UnicodeBypassValidationFlow::PathNode sink
where UnicodeBypassValidationFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This $@ processes unsafely $@ and any logical validation in-between could be bypassed using special Unicode characters.",
  sink.getNode(), "Unicode transformation (Unicode normalization)", source.getNode(),
  "remote user-controlled data"
