import python

predicate reaches_exit(Name u) {
  u.uses(_) and
  exists(ControlFlowNode f, BasicBlock b | f.getNode() = u and f.getBasicBlock() = b |
    b.reachesExit()
  )
}

from Name u
where reaches_exit(u) and u.getVariable() instanceof GlobalVariable
select u.toString()
