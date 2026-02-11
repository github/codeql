/**
 * query-type: graph
 *
 * @kind graph-equivalence-test
 */

import sbb_test

// Note: no instance of `SubBasicBlockCutNode`
from boolean isEdge, SubBasicBlock x, SubBasicBlock y, string label
where isNode(isEdge, x, y, label) or isSuccessor(isEdge, x, y, label)
select x.getEnclosingFunction().toString(), isEdge, x, y, label
