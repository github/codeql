/**
 * @name AV Rule 50
 * @description The first word of the name of a class, structure, namespace, enumeration, or type created with typedef will begin with an uppercase letter. All other letters will be lowercase.
 * @kind problem
 * @id cpp/jsf/av-rule-50
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp
import Naming

predicate relevant(Element elem, Element blame, string kind, string name) {
  exists(Class c | elem = c and blame = c and kind = "class or struct" and name = c.getName()) // includes struct
  or
  exists(Namespace n |
    elem = n and blame = n.getADeclarationEntry() and kind = "namespace" and name = n.getName()
  )
  or
  exists(Enum e | elem = e and blame = e and kind = "enumeration" and name = e.getName())
  or
  exists(TypedefType t | elem = t and blame = t and kind = "typedef" and name = t.getName())
}

from Element d, Element blame, Word w, int pos, string kind, string name
where
  relevant(d, blame, kind, name) and
  w = name.(Name).getWord(pos) and
  not (w.couldBeUppercaseAcronym() and w != name) and
  (
    pos = 0 and not w.isCapitalized()
    or
    pos > 0 and not w.isLowercase()
  )
select blame,
  "AV Rule 50: The first word of a " + kind +
    " will begin with an uppercase letter, and all other letters will be lowercase."
