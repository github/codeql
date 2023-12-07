/** Provides utility predicates relating to switch cases. */

import java

/**
 * Gets the `i`th `PatternCase` defined on `switch`, if one exists.
 */
private PatternCase getPatternCase(SwitchBlock switch, int i) {
  result =
    rank[i + 1](PatternCase pc, int caseIdx | pc.isNthCaseOf(switch, caseIdx) | pc order by caseIdx)
}

/**
 * Gets the first `PatternCase` defined on `switch`, if one exists.
 */
PatternCase getFirstPatternCase(SwitchBlock switch) { result = getPatternCase(switch, 0) }

/**
 * Gets the PatternCase after pc, if one exists.
 */
PatternCase getNextPatternCase(PatternCase pc) {
  exists(int idx, SwitchBlock switch |
    pc = getPatternCase(switch, idx) and result = getPatternCase(switch, idx + 1)
  )
}

int lastCaseIndex(SwitchBlock switch) {
  result = max(int i | any(SwitchCase c).isNthCaseOf(switch, i))
}
