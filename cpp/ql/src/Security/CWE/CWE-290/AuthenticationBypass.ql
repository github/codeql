/**
 * @name Authentication bypass by spoofing
 * @description Authentication by checking that the peer's address
 *              matches a known IP or web address is unsafe as it is
 *              vulnerable to spoofing attacks.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/user-controlled-bypass
 * @tags security
 *       external/cwe/cwe-290
 */

import semmle.code.cpp.security.TaintTracking

predicate hardCodedAddressOrIP(StringLiteral txt) {
  exists(string s
  | s = txt.getValueText()
  | // Hard-coded ip addresses, such as 127.0.0.1
    s.regexpMatch("\"[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+\"") or

    // Hard-coded addresses such as www.mycompany.com
    s.matches("\"www.%\"") or
    s.matches("\"http:%\"") or
    s.matches("\"https:%\"") or
    s.matches("\"%.com\"") or
    s.matches("\"%.ru\"") or
    s.matches("\"%.net\"") or
    s.matches("\"%.org\"") or
    s.matches("\"%.de\"") or
    s.matches("\"%.jp\"") or
    s.matches("\"%.uk\"") or
    s.matches("\"%.br\"") or
    s.matches("\"%.pl\"") or
    s.matches("\"%.in\"") or
    s.matches("\"%.it\"") or
    s.matches("\"%.fr\"") or
    s.matches("\"%.au\"") or
    s.matches("\"%.info\"") or
    s.matches("\"%.nl\"") or
    s.matches("\"%.cn\"") or
    s.matches("\"%.ir\"") or
    s.matches("\"%.es\"") or
    s.matches("\"%.cz\"") or
    s.matches("\"%.biz\"") or
    s.matches("\"%.ca\"") or
    s.matches("\"%.eu\"") or
    s.matches("\"%.ua\"") or
    s.matches("\"%.kr\"") or
    s.matches("\"%.za\"") or
    s.matches("\"%.co\"") or
    s.matches("\"%.gr\"") or
    s.matches("\"%.ro\"") or
    s.matches("\"%.se\"") or
    s.matches("\"%.tw\"") or
    s.matches("\"%.vn\"") or
    s.matches("\"%.mx\"") or
    s.matches("\"%.ch\"") or
    s.matches("\"%.tr\"") or
    s.matches("\"%.at\"") or
    s.matches("\"%.be\"") or
    s.matches("\"%.hu\"") or
    s.matches("\"%.tv\"") or
    s.matches("\"%.dk\"") or
    s.matches("\"%.me\"") or
    s.matches("\"%.ar\"") or
    s.matches("\"%.us\"") or
    s.matches("\"%.no\"") or
    s.matches("\"%.sk\"") or
    s.matches("\"%.fi\"") or
    s.matches("\"%.id\"") or
    s.matches("\"%.cl\"") or
    s.matches("\"%.nz\"") or
    s.matches("\"%.by\"") or
    s.matches("\"%.xyz\"") or
    s.matches("\"%.pt\"") or
    s.matches("\"%.ie\"") or
    s.matches("\"%.il\"") or
    s.matches("\"%.kz\"") or
    s.matches("\"%.my\"") or
    s.matches("\"%.hk\"") or
    s.matches("\"%.lt\"") or
    s.matches("\"%.cc\"") or
    s.matches("\"%.sg\"") or
    s.matches("\"%.io\"") or
    s.matches("\"%.edu\"") or
    s.matches("\"%.gov\""))
}

predicate useOfHardCodedAddressOrIP(Expr use) {
  hardCodedAddressOrIP(use) or
  exists(Expr def, Expr src, Variable v
  | useOfHardCodedAddressOrIP(src) and
    exprDefinition(v, def, src) and
    definitionUsePair(v, def, use))
}

/**
 * Find `IfStmt`s that have a hard-coded IP or web address in
 * their condition. If the condition also depends on an
 * untrusted input then it might be vulnerable to a spoofing
 * attack.
 */
predicate hardCodedAddressInCondition(Expr source, Expr condition) {
  // One of the sub-expressions of the condition is tainted.
  exists(Expr taintedExpr
  | taintedExpr.getParent+() = condition
  | tainted(source, taintedExpr)) and

  // One of the sub-expressions of the condition is a hard-coded
  // IP or web-address.
  exists(Expr use
  | use.getParent+() = condition
  | useOfHardCodedAddressOrIP(use)) and

  condition = any(IfStmt ifStmt).getCondition()
}

from Expr source, Expr condition
where hardCodedAddressInCondition(source, condition)
select
  condition,
  "Untrusted input $@ might be vulnerable to a spoofing attack.",
  source, source.toString()
