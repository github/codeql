import python

predicate string_attribute_all(ControlFlowNode n, string attr) {
  (n.getNode() instanceof Unicode or n.getNode() instanceof Bytes) and
  attr = "const"
  or
  exists(Object s |
    n.refersTo(s, theBytesType(), _) and
    attr = "bytes" and
    // We are only interested in bytes if they may cause an exception if
    // implicitly converted to unicode. ASCII is safe.
    not s.(StringObject).isAscii()
  )
}

predicate tracked_object(ControlFlowNode obj, string attr) {
  tracked_object_all(obj, attr)
  or
  tracked_object_any(obj, attr)
}

predicate open_file(Object obj) { obj.(CallNode).getFunction().refersTo(Object::builtin("open")) }

predicate string_attribute_any(ControlFlowNode n, string attr) {
  attr = "user-input" and
  exists(Object input | n.(CallNode).getFunction().refersTo(input) |
    if major_version() = 2
    then input = Object::builtin("raw_input")
    else input = Object::builtin("input")
  )
  or
  attr = "file-input" and
  exists(Object fd | n.(CallNode).getFunction().(AttrNode).getObject("read").refersTo(fd) |
    open_file(fd)
  )
  or
  n.refersTo(_, theUnicodeType(), _) and attr = "unicode"
}

predicate tracked_object_any(ControlFlowNode obj, string attr) {
  string_attribute_any(obj, attr)
  or
  exists(ControlFlowNode other | tracking_step(other, obj) | tracked_object_any(other, attr))
}

predicate tracked_object_all(ControlFlowNode obj, string attr) {
  string_attribute_all(obj, attr)
  or
  forex(ControlFlowNode other | tracking_step(other, obj) | tracked_object_all(other, attr))
}

predicate tracked_call_step(ControlFlowNode ret, ControlFlowNode call) {
  exists(FunctionObject func, Return r |
    func.getACall() = call and
    func.getFunction() = r.getScope() and
    r.getValue() = ret.getNode()
  )
}

ControlFlowNode sequence_for_iterator(ControlFlowNode f) {
  exists(For for | f.getNode() = for.getTarget() |
    result.getNode() = for.getIter() and
    result.getBasicBlock().dominates(f.getBasicBlock())
  )
}

pragma[noinline]
private predicate tracking_step(ControlFlowNode src, ControlFlowNode dest) {
  src = dest.(BinaryExprNode).getAnOperand()
  or
  src = dest.(UnaryExprNode).getOperand()
  or
  src = sequence_for_iterator(dest)
  or
  src = dest.(AttrNode).getObject()
  or
  src = dest.(SubscriptNode).getObject()
  or
  tracked_call_step(src, dest)
  or
  dest.refersTo(src.(Object))
}
