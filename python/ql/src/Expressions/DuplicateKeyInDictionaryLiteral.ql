/**
 * @name Duplicate key in dict literal
 * @description Duplicate key in dict literal. All but the last will be lost.
 * @kind problem
 * @tags quality
 *       maintainability
 *       useless-code
 *       external/cwe/cwe-561
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/duplicate-key-dict-literal
 */

import python
import semmle.python.strings

predicate dict_key(Dict d, Expr k, string s) {
  k = d.getAKey() and
  (
    s = k.(Num).getN()
    or
    // We use � to mark unrepresentable characters
    // so two instances of � may represent different strings in the source code
    not "�" = s.charAt(_) and
    exists(StringLiteral c | c = k |
      s = "u\"" + c.getText() + "\"" and c.isUnicode()
      or
      s = "b\"" + c.getText() + "\"" and not c.isUnicode()
    )
  )
}

from Dict d, Expr k1, Expr k2
where
  exists(string s | dict_key(d, k1, s) and dict_key(d, k2, s) and k1 != k2) and
  (
    exists(BasicBlock b, int i1, int i2 |
      b.getNode(i1).getNode() = k1 and
      b.getNode(i2).getNode() = k2 and
      i1 < i2
    )
    or
    exists(ControlFlowNode k1Cfg, ControlFlowNode k2Cfg |
      k1Cfg.getNode() = k1 and k2Cfg.getNode() = k2
    |
      k1Cfg.getBasicBlock().strictlyDominates(k2Cfg.getBasicBlock())
    )
  )
select k1, "Dictionary key " + repr(k1) + " is subsequently $@.", k2, "overwritten"
