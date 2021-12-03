import java

query predicate lambdaClassMembers(Class c, Callable m, string n, string signature) {
  c.getASupertype().hasQualifiedName("kotlin.jvm.internal", "Lambda") and
  c.getAMember() = m and
  n = m.getAPrimaryQlClass() and
  signature = m.getSignature()
}

query predicate lambdaClassInterfaces(Class c, string iName) {
  c.getASupertype().hasQualifiedName("kotlin.jvm.internal", "Lambda") and
  exists(Interface i | c.extendsOrImplements(i) and i.getName() = iName)
}