/**
 * @kind graph
 */

import codeql.Locations
import codeql_ruby.regexp.RegExpTreeView as RETV

query predicate nodes(RETV::RegExpTerm n, string attr, string val) {
  attr = "semmle.label" and
  val = "[" + concat(n.getAPrimaryQlClass(), ", ") + "] " + n.toString()
  or
  attr = "semmle.order" and
  exists(int i, RETV::RegExpTerm p | p.getChild(i) = n | val = i.toString())
}

query predicate edges(RETV::RegExpTerm pred, RETV::RegExpTerm succ, string attr, string val) {
  attr in ["semmle.label", "semmle.order"] and
  val = any(int i | succ = pred.getChild(i)).toString()
}
