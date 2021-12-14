import cpp

from LocalVariable lv, ControlFlowNode def
where
  def = lv.getAnAssignment() and
  not exists(VariableAccess use |
    use = lv.getAnAccess() and
    use = def.getASuccessor+()
  )
select lv, def