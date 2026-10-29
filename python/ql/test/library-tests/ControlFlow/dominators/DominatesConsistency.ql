import python

select count(BasicBlock b1, BasicBlock b2 |
    b1 = b2.getImmediateDominator+() and not b1.strictlyDominates(b2)
  ),
  count(BasicBlock b1, BasicBlock b2 |
    not b1 = b2.getImmediateDominator+() and b1.strictlyDominates(b2)
  )
