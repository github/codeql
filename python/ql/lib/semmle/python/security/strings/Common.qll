import python

/* A call that returns a copy (or similar) of the argument */
predicate copy_call(ControlFlowNode fromnode, CallNode tonode) {
  tonode.getFunction().(AttrNode).getObject("copy") = fromnode
  or
  exists(ModuleValue copy, string name | name = "copy" or name = "deepcopy" |
    copy.attr(name).(FunctionValue).getACall() = tonode and
    tonode.getArg(0) = fromnode
  )
  or
  tonode.getFunction().pointsTo(Value::named("reversed")) and
  tonode.getArg(0) = fromnode
}
