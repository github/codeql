/**
 * @kind graph
 */

import codeql.Locations
import codeql.ruby.security.performance.RegExpTreeView as RETV

query predicate nodes(RETV::RegExpTerm n, string attr, string val) {
  attr = "semmle.label" and
  val = "[" + concat(n.getAPrimaryQlClass(), ", ") + "] " + n.toString()
  or
  attr = "semmle.order" and
  val =
    any(int i |
      n =
        rank[i](RETV::RegExpTerm t, string fp, int sl, int sc, int el, int ec |
          t.hasLocationInfo(fp, sl, sc, el, ec)
        |
          t order by fp, sl, sc, el, ec, t.toString()
        )
    ).toString()
}

query predicate edges(RETV::RegExpTerm pred, RETV::RegExpTerm succ, string attr, string val) {
  attr in ["semmle.label", "semmle.order"] and
  val = any(int i | succ = pred.getChild(i)).toString()
}
