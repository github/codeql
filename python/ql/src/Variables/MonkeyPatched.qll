import python


predicate monkey_patched_builtin(string name) {
    exists(AttrNode attr, SubscriptNode subscr, StrConst s | 
        subscr.isStore() and
        subscr.getIndex().getNode() = s and
        s.getText() = name and
        subscr.getValue() = attr and
        attr.getObject("__dict__").refersTo(theBuiltinModuleObject())
    )
    or
    exists(CallNode call, ControlFlowNode bltn, StrConst s | 
        call.getArg(0) = bltn and
        bltn.refersTo(theBuiltinModuleObject()) and
        call.getArg(1).getNode() = s and
        s.getText() = name and
        call.getFunction().refersTo(Object::builtin("setattr"))
    )
    or
    exists(AttrNode attr | 
        attr.isStore() and
        attr.getObject(name).refersTo(theBuiltinModuleObject())
    )
}
