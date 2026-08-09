/**
 * @name Test for operators
 */

import csharp

from CompoundAssignmentOperator cao, CompoundAssignmentOperatorCall call
where call.getTarget() = cao
select cao, call
