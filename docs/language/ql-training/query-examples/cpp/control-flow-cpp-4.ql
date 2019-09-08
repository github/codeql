import cpp

predicate isReachable(BasicBlock bb) {
  bb instanceof EntryBasicBlock or
  isReachable(bb.getAPredecessor())
}

from BasicBlock bb
where not isReachable(bb)
select bb