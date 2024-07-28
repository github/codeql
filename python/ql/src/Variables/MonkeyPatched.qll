import python

predicate monkey_patched_builtin(string name) {
  exists(AttrNode attr, SubscriptNode subscr, StringLiteral s |
    subscr.isStore() and
    subscr.getIndex().getNode() = s and
    s.getText() = name and
    subscr.getObject() = attr and
    attr.getObject("__dict__").pointsTo(Module::builtinModule())
  )
  or
  exists(CallNode call, ControlFlowNode bltn, StringLiteral s |
    call.getArg(0) = bltn and
    bltn.pointsTo(Module::builtinModule()) and
    call.getArg(1).getNode() = s and
    s.getText() = name and
    call.getFunction().pointsTo(Value::named("setattr"))
  )
  or
  exists(AttrNode attr |
    attr.isStore() and
    attr.getObject(name).pointsTo(Module::builtinModule())
  )
}
