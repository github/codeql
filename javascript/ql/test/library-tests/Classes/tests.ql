import javascript

query predicate test_FieldInits(FieldDefinition field, Expr res) { res = field.getInit() }

query predicate test_ComputedMethods(MethodDefinition md) { md.isComputed() }

query predicate test_StaticMethods(MethodDefinition md) { md.isStatic() }

query predicate test_ClassDefinition_getSuperClass(ClassDefinition cd, Expr res) {
  res = cd.getSuperClass()
}

query predicate test_ClassNodeStaticMethod(
  DataFlow::ClassNode class_, string name, DataFlow::FunctionNode res
) {
  res = class_.getStaticMethod(name)
}

query predicate test_ClassDefinitions(ClassDefinition cd) { any() }

query predicate test_AccessorMethods(AccessorMethodDefinition amd) { any() }

query predicate test_Fields(FieldDefinition field, Expr res) { res = field.getNameExpr() }

query predicate test_ClassDefinition_getName(ClassDefinition cd, string res) { res = cd.getName() }

query predicate test_MethodDefinitions(
  MethodDefinition md, Expr res0, FunctionExpr res1, ClassDefinition res2
) {
  res0 = md.getNameExpr() and res1 = md.getBody() and res2 = md.getDeclaringClass()
}

query predicate test_getAMember(ClassDefinition c, MemberDeclaration res) { res = c.getAMember() }

query predicate test_MethodNames(MethodDefinition md, string res) { res = md.getName() }

query predicate test_NewTargetExpr(NewTargetExpr e) { any() }

query predicate test_SuperExpr(SuperExpr s) { any() }

query predicate test_SyntheticConstructors(ConstructorDefinition cd) { cd.isSynthetic() }

query predicate test_ConstructorDefinitions(ConstructorDefinition cd) { any() }

query predicate test_ClassNodeConstructor(DataFlow::ClassNode class_, DataFlow::FunctionNode res) {
  res = class_.getConstructor()
}

query predicate test_ClassNodeInstanceMethod(
  DataFlow::ClassNode class_, string name, DataFlow::FunctionNode res
) {
  res = class_.getInstanceMethod(name)
}

query string getAccessModifier(DataFlow::PropRef ref, Expr prop) {
  prop = ref.getPropertyNameExpr() and
  if ref.isPrivateField() then result = "Private" else result = "Public"
}

class Configuration extends DataFlow::Configuration {
  Configuration() { this = "ClassDataFlowTestingConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.getEnclosingExpr().(StringLiteral).getValue().toLowerCase() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument() = sink
  }
}

query predicate dataflow(DataFlow::Node pred, DataFlow::Node succ) {
  any(Configuration c).hasFlow(pred, succ)
}

query BlockStmt staticInitializer(ClassDefinition cd) { result = cd.getAStaticInitializerBlock() }

query Identifier privateIdentifier() { result.getName().matches("#%") }
