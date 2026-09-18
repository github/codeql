/**
 * @kind graph
 */

import cpp
import semmle.code.cpp.regex.RegexTreeView

query predicate nodes(RegExpTerm n, string attr, string val) {
  attr = "semmle.label" and
  val = "[" + concat(n.getAPrimaryQlClass(), ", ") + "] " + n.toString()
  or
  attr = "semmle.order" and
  val =
    any(int i |
      n =
        rank[i](RegExpTerm t, string fp, int sl, int sc, int el, int ec |
          t.hasLocationInfo(fp, sl, sc, el, ec)
        |
          t order by fp, sl, sc, el, ec, t.toString()
        )
    ).toString()
}

query predicate edges(RegExpTerm pred, RegExpTerm succ, string attr, string val) {
  attr in ["semmle.label", "semmle.order"] and
  val = any(int i | succ = pred.getChild(i)).toString()
}
