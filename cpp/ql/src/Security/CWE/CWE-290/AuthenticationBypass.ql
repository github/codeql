/**
 * @name Authentication bypass by spoofing
 * @description Authentication by checking that the peer's address
 *              matches a known IP or web address is unsafe as it is
 *              vulnerable to spoofing attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision medium
 * @id cpp/user-controlled-bypass
 * @tags security
 *       external/cwe/cwe-290
 */

import semmle.code.cpp.ir.dataflow.internal.DefaultTaintTrackingImpl
import TaintedWithPath

string getATopLevelDomain() {
  result =
    [
      "com", "ru", "net", "org", "de", "jp", "uk", "br", "pl", "in", "it", "fr", "au", "info", "nl",
      "cn", "ir", "es", "cz", "biz", "ca", "eu", "ua", "kr", "za", "co", "gr", "ro", "se", "tw",
      "vn", "mx", "ch", "tr", "at", "be", "hu", "tv", "dk", "me", "ar", "us", "no", "sk", "fi",
      "id", "cl", "nz", "by", "xyz", "pt", "ie", "il", "kz", "my", "hk", "lt", "cc", "sg", "io",
      "edu", "gov"
    ]
}

predicate hardCodedAddressOrIP(StringLiteral txt) {
  exists(string s | s = txt.getValueText() |
    // Hard-coded ip addresses, such as 127.0.0.1
    s.regexpMatch("\"[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+\"") or
    // Hard-coded addresses such as www.mycompany.com
    s.regexpMatch("\"(www\\.|http:|https:).*\"") or
    s.regexpMatch("\".*\\.(" + strictconcat(getATopLevelDomain(), "|") + ")\"")
  )
}

predicate useOfHardCodedAddressOrIP(Expr use) {
  hardCodedAddressOrIP(use)
  or
  exists(Expr def, Expr src, Variable v |
    useOfHardCodedAddressOrIP(src) and
    exprDefinition(v, def, src) and
    definitionUsePair(v, def, use)
  )
}

/**
 * Find `IfStmt`s that have a hard-coded IP or web address in
 * their condition. If the condition also depends on an
 * untrusted input then it might be vulnerable to a spoofing
 * attack.
 */
predicate hardCodedAddressInCondition(Expr subexpression, Expr condition) {
  subexpression = condition.getAChild+() and
  // One of the sub-expressions of the condition is a hard-coded
  // IP or web-address.
  exists(Expr use | use = condition.getAChild+() | useOfHardCodedAddressOrIP(use)) and
  condition = any(IfStmt ifStmt).getCondition()
}

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element sink) { hardCodedAddressInCondition(sink, _) }
}

from Expr subexpression, Expr source, Expr condition, PathNode sourceNode, PathNode sinkNode
where
  hardCodedAddressInCondition(subexpression, condition) and
  taintedWithPath(source, subexpression, sourceNode, sinkNode)
select condition, sourceNode, sinkNode,
  "Untrusted input $@ might be vulnerable to a spoofing attack.", source, source.toString()
