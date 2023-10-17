/**
 * @name Double escaping or unescaping
 * @description When escaping special characters using a meta-character like backslash or
 *              ampersand, the meta-character has to be escaped first to avoid double-escaping,
 *              and conversely it has to be unescaped last to avoid double-unescaping.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id js/double-escaping
 * @tags correctness
 *       security
 *       external/cwe/cwe-116
 *       external/cwe/cwe-020
 */

import javascript

from Replacement primary, Replacement supplementary, string message, string metachar
where
  primary.escapes(metachar, _) and
  supplementary = primary.getAnEarlierEscaping(metachar) and
  message = "may double-escape '" + metachar + "' characters from $@"
  or
  primary.unescapes(_, metachar) and
  supplementary = primary.getALaterUnescaping(metachar) and
  message = "may produce '" + metachar + "' characters that are double-unescaped $@"
select primary, "This replacement " + message + ".", supplementary, "here"
