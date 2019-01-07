/**
 * @name Malformed JSLint directive
 * @description A malformed JSLint directive will be rejected by JSLint, and may be either
 *              rejected or ignored by other tools.
 * @kind problem
 * @problem.severity recommendation
 * @id js/jslint/malformed-directive
 * @tags maintainability
 * @precision medium
 * @deprecated JSLint is rarely used any more. Deprecated since 1.17.
 */

import javascript

from JSLintDirective dir, string flag, string flags, string directive
where
  // a flag, optionally followed by a colon and a value, where the value may be
  // a Boolean or a number
  flag = "[a-zA-Z$_][a-zA-Z0-9$_]*(\\s*:\\s*(true|false|\\d+))?" and
  // a non-empty, comma-separated list of flags
  flags = "(" + flag + "\\s*,\\s*)*" + flag and
  // a word (which is the directive's name), followed by a possibly empty list of flags
  // note that there may be trailing whitespace, but no leading whitespace
  directive = "\\s*\\w+\\s+(" + flags + ")?\\s*" and
  not dir.getText().regexpMatch(directive)
select dir, "Malformed JSLint directive."
