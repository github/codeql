import ruby

query DataFlow::Node getAnAncestorExpr(DataFlow::ModuleNode mod) {
  result = mod.getAnAncestorExpr()
}

query DataFlow::ModuleNode getAnAncestor(DataFlow::ModuleNode mod) { result = mod.getAnAncestor() }

query DataFlow::Node getModuleLevelSelf(DataFlow::ModuleNode mod) {
  result = mod.getModuleLevelSelf()
}

query DataFlow::Node getAnImmediateReference(DataFlow::ModuleNode mod) {
  result = mod.getAnImmediateReference()
}

query DataFlow::MethodNode getOwnInstanceMethod(DataFlow::ModuleNode mod, string name) {
  result = mod.getOwnInstanceMethod(name)
}

query DataFlow::MethodNode getInstanceMethod(DataFlow::ModuleNode mod, string name) {
  result = mod.getInstanceMethod(name)
}

query DataFlow::Node getAnOwnInstanceSelf(DataFlow::ModuleNode mod) {
  result = mod.getAnOwnInstanceSelf()
}

query DataFlow::Node getAnInstanceSelf(DataFlow::ModuleNode mod) {
  result = mod.getAnInstanceSelf()
}

query DataFlow::Node getOwnSingletonMethod(DataFlow::ModuleNode mod, string name) {
  result = mod.getOwnSingletonMethod(name)
}

query DataFlow::Node getAnOwnInstanceVariableRead(DataFlow::ModuleNode mod, string name) {
  result = mod.getAnOwnInstanceVariableRead(name)
}

query DataFlow::Node getAnOwnInstanceVariableWriteValue(DataFlow::ModuleNode mod, string name) {
  result = mod.getAnOwnInstanceVariableWriteValue(name)
}

query DataFlow::ModuleNode getParentModule(DataFlow::ModuleNode mod) {
  result = mod.getParentModule()
}

query DataFlow::ModuleNode getNestedModule(DataFlow::ModuleNode mod, string name) {
  result = mod.getNestedModule(name)
}

query DataFlow::Node getTopLevelConst(string name) { result = DataFlow::getConstant(name) }

query DataFlow::Node getConstant(DataFlow::ConstRef base, string name) {
  result = base.getConstant(name)
}

query DataFlow::ModuleNode getXYClasses() {
  result = DataFlow::getConstant("X").getConstant("Y").getADescendentModule()
}

query DataFlow::HashLiteralNode hashLiteralNode() { any() }

query DataFlow::Node hashLiteralKey(DataFlow::HashLiteralNode node, string key) {
  result = node.getElementFromKey(Ast::ConstantValue::fromStringlikeValue(key))
}

query DataFlow::ArrayLiteralNode arrayLiteralNode() { any() }

query DataFlow::Node arrayLiteralElement(DataFlow::ArrayLiteralNode node) {
  result = node.getAnElement()
}
