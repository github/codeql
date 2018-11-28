/**
 * @name Partial macro
 * @description Macros must expand to complete syntactic units -- "#define MY_IF if(" is not legal.
 * @kind problem
 * @id cpp/jpl-c/preprocessor-use-partial
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

predicate incomplete(Macro m) {
  exists(string body | body = m.getBody() and not m.getBody().matches("%\\") |
    body.regexpMatch("[^(]*\\).*") or
    body.regexpMatch("[^\\[]*].*") or
    body.regexpMatch("[^{]*}.*") or
    body.regexpMatch(".*\\([^)]*") or
    body.regexpMatch(".*\\[[^\\]]*") or
    body.regexpMatch(".*\\{[^}]*") or
    count(body.indexOf("(")) != count(body.indexOf(")")) or
    count(body.indexOf("[")) != count(body.indexOf("]")) or
    count(body.indexOf("{")) != count(body.indexOf("}"))
  )
}

from Macro m
where incomplete(m)
select m, "The macro " + m.getHead() + " will not expand into a syntactic unit."
