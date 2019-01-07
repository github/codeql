/**
 * @name Invalid JSLint directive
 * @description A JSLint directive that has whitespace characters before the
 *              directive name is not recognized by JSLint.
 * @kind problem
 * @problem.severity recommendation
 * @id js/jslint/invalid-directive
 * @tags maintainability
 * @precision medium
 * @deprecated JSLint is rarely used any more. Deprecated since 1.17.
 */

import javascript

from SlashStarComment c
where
  // use possessive quantifiers '*+' and '++' to avoid backtracking
  c
      .getText()
      .regexpMatch("\\s+(global|properties|property|jslint)\\s(\\s*+[a-zA-Z$_][a-zA-Z0-9$_]*+(\\s*+:\\s*+\\w++)?\\s*+,?)++\\s*")
select c, "JSLint directives must not have whitespace characters before the directive name."
