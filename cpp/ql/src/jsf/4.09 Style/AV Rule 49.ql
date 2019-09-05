/**
 * @name AV Rule 49
 * @description All acronyms in an identifier will be composed of uppercase letters.
 * @kind problem
 * @id cpp/jsf/av-rule-49
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp
import Naming

/*
 * CUSTOMIZATION: see the `Naming.qll` file for how to add custom acronyms.
 */

from Declaration d, Name n, Word w
where
  d.fromSource() and
  n = d.getName() and
  w = n.getAWord() and
  w.isDefiniteAcronym() and
  not w.isUppercase()
select d,
  "AV Rule 49:  acronyms in identifiers will be uppercase. Incorrect case for acronym " +
    w.toString() + "."
