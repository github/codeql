lgtm,codescanning
* The predicates `StepSummary::step` and `TypeTracker::step` in `TypeTracker.qll` have been changed
  to use the more restrictive type `LocalSourceNode` for their second argument. For cases where
  stepping between non-`LocalSourceNode`s is required, the `StepSummary::smallstep` predicate may be
  used instead.
* The methods `Node::track` and `Node::backtrack` have been moved to the class `LocalSourceNode`. If
  the old behavior is required, one can use `LocalSourceNode::flowsTo` to add back the missing flow.