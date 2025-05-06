import javascript

query predicate fieldStep(DataFlow::Node pred, DataFlow::Node succ) {
  DataFlow::localFieldStep(pred, succ)
}

query DataFlow::SourceNode getAReceiverNode(DataFlow::ClassNode cls) {
  result = cls.getAReceiverNode()
}

query TypeAnnotation getFieldTypeAnnotation(DataFlow::ClassNode cls, string name) {
  result = cls.getFieldTypeAnnotation(name)
}

query predicate instanceMember(
  DataFlow::ClassNode cls, string name, string kind, DataFlow::FunctionNode inst, string clsName
) {
  cls.getInstanceMember(name, kind) = inst and clsName = cls.getName()
}

query predicate instanceMethod(
  DataFlow::ClassNode cls, string name, DataFlow::FunctionNode inst, string clsName
) {
  cls.getInstanceMethod(name) = inst and clsName = cls.getName()
}

query predicate staticMember(
  DataFlow::ClassNode cls, string name, string kind, DataFlow::FunctionNode inst, string clsName
) {
  cls.getStaticMember(name, kind) = inst and clsName = cls.getName()
}

query predicate superClass(
  DataFlow::ClassNode cls, DataFlow::ClassNode sup, string clsName, string supName
) {
  sup = cls.getADirectSuperClass() and
  clsName = cls.getName() and
  supName = sup.getName()
}
