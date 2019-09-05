/**
 * @name AV Rule 46
 * @description User-specified identifiers (internal and external) will not rely on significance of more than 64 characters.
 * @kind problem
 * @id cpp/jsf/av-rule-46
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

/*
 * This is a bit off, because the two nameables could be in different scopes
 * or in different name ranges entirely. However it is infrequent enough to
 * require > 64 chars significance, and it would be bad practice in any case
 */

predicate longNameSignificance(Element e, string significance) {
  exists(string name |
    elementName(e, name) and
    name.length() > 64 and
    significance = name.substring(0, 64)
  )
}

predicate elementName(Element e, string name) {
  name = e.(Declaration).getName() or name = e.(Namespace).getName()
}

predicate clash(Element e1, Element e2) {
  exists(string significance, string n1, string n2 |
    longNameSignificance(e1, significance) and
    longNameSignificance(e2, significance) and
    elementName(e1, n1) and
    elementName(e2, n2) and
    n1 != n2
  )
}

from Element e1, Element e2, string name
where
  clash(e1, e2) and
  elementName(e2, name)
select e1, "AV Rule 46: relies on more than 64 characters to separate from " + name
