/**
 * @name AV Rule 45
 * @description All words in an identifier will be separated by the underscore character.
 * @kind problem
 * @id cpp/jsf/av-rule-45
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

/*
 * INTERPRETATION: just check for the absence of camel-case, ie
 * forbid 'aB' in identifier names
 */

from Declaration d, string name, string lowerCase, string upperCase, int pos
where
  name = d.getName() and
  d.fromSource() and
  lowerCase = name.charAt(pos) and
  upperCase = name.charAt(pos + 1) and
  lowerCase.regexpMatch("[a-z]") and
  upperCase.regexpMatch("[A-Z]")
select d,
  "AV Rule 45: All words in an identifier will be separated by the underscore character. Camel-case is not allowed."
