/** Provides utility predicates relating to switch cases. */

import java

/**
 * Gets the `i`th `SwitchCase` defined on `switch`, if one exists.
 */
SwitchCase getCase(StmtParent switch, int i) {
  result = switch.(SwitchExpr).getCase(i) or result = switch.(SwitchStmt).getCase(i)
}

/**
 * Gets the `i`th `PatternCase` defined on `switch`, if one exists.
 */
PatternCase getPatternCase(StmtParent switch, int i) {
  result =
    rank[i + 1](PatternCase pc, int caseIdx | pc = getCase(switch, caseIdx) | pc order by caseIdx)
}

/**
 * Gets the PatternCase after pc, if one exists.
 */
PatternCase getNextPatternCase(PatternCase pc) {
  exists(int idx, StmtParent switch |
    pc = getPatternCase(switch, idx) and result = getPatternCase(switch, idx + 1)
  )
}

int lastCaseIndex(StmtParent switch) {
  result = max(int i | any(SwitchCase c).isNthCaseOf(switch, i))
}
