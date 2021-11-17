import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.internal.ContainerFlow
private import semmle.code.java.dataflow.internal.DataFlowImplCommon
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.internal.DataFlowPrivate

Method superImpl(Method m) {
  result = m.getAnOverride() and
  not exists(result.getAnOverride()) and
  not m instanceof ToStringMethod
}

class TargetAPI extends Callable {
  TargetAPI() {
    this.isPublic() and
    this.fromSource() and
    (
      this.getDeclaringType().isPublic() or
      superImpl(this).getDeclaringType().isPublic()
    ) and
    isRelevantForModels(this)
  }
}

private string isExtensible(RefType ref) {
  if ref.isFinal() then result = "false" else result = "true"
}

predicate isRelevantForModels(Callable api) {
  not isInTestFile(api.getCompilationUnit().getFile()) and
  not isJdkInternal(api.getCompilationUnit())
}

private predicate isInTestFile(File file) {
  file.getAbsolutePath().matches("%src/test/%") or
  file.getAbsolutePath().matches("%/guava-tests/%") or
  file.getAbsolutePath().matches("%/guava-testlib/%")
}

private predicate isJdkInternal(CompilationUnit cu) {
  cu.getPackage().getName().matches("org.graalvm%") or
  cu.getPackage().getName().matches("com.sun%") or
  cu.getPackage().getName().matches("javax.swing%") or
  cu.getPackage().getName().matches("java.awt%") or
  cu.getPackage().getName().matches("sun%") or
  cu.getPackage().getName().matches("jdk.%") or
  cu.getPackage().getName().matches("java2d.%") or
  cu.getPackage().getName().matches("build.tools.%") or
  cu.getPackage().getName().matches("propertiesparser.%") or
  cu.getPackage().getName().matches("org.jcp.%") or
  cu.getPackage().getName().matches("org.w3c.%") or
  cu.getPackage().getName().matches("org.ietf.jgss.%") or
  cu.getPackage().getName().matches("org.xml.sax%") or
  cu.getPackage().getName() = "compileproperties" or
  cu.getPackage().getName() = "netscape.javascript" or
  cu.getPackage().getName() = ""
}

bindingset[input, output]
string asTaintModel(TargetAPI api, string input, string output) {
  result = asSummaryModel(api, input, output, "taint")
}

bindingset[input, output]
string asValueModel(TargetAPI api, string input, string output) {
  result = asSummaryModel(api, input, output, "value")
}

bindingset[input, output, kind]
string asSummaryModel(TargetAPI api, string input, string output, string kind) {
  result =
    asPartialModel(api) + input + ";" //
      + output + ";" //
      + kind
}

bindingset[input, kind]
string asSinkModel(TargetAPI api, string input, string kind) {
  result = asPartialModel(api) + input + ";" + kind
}

bindingset[output, kind]
string asSourceModel(TargetAPI api, string output, string kind) {
  result = asPartialModel(api) + output + ";" + kind
}

/**
 * Computes the first 6 columns for CSV rows.
 */
private string asPartialModel(TargetAPI api) {
  result =
    typeAsSummaryModel(api) + ";" //
      + isExtensible(bestTypeForModel(api)) + ";" //
      + api.getName() + ";" //
      + paramsString(api) + ";" //
      + /* ext + */ ";" //
}

/**
 * Returns the appropriate type name for the model. Either the type
 * declaring the method or the supertype introducing the method.
 */
private string typeAsSummaryModel(TargetAPI api) { result = typeAsModel(bestTypeForModel(api)) }

private RefType bestTypeForModel(TargetAPI api) {
  if exists(superImpl(api))
  then superImpl(api).fromSource() and result = superImpl(api).getDeclaringType()
  else result = api.getDeclaringType()
}

private string typeAsModel(RefType type) {
  result = type.getCompilationUnit().getPackage().getName() + ";" + type.nestedName()
}

predicate isRelevantType(Type t) {
  not t instanceof TypeClass and
  not t instanceof EnumType and
  not t instanceof PrimitiveType and
  not t instanceof BoxedType and
  not t.(RefType).getAnAncestor().hasQualifiedName("java.lang", "Number") and
  not t.(RefType).getAnAncestor().hasQualifiedName("java.nio.charset", "Charset") and
  (
    not t.(Array).getElementType() instanceof PrimitiveType or
    isPrimitiveTypeUsedForBulkData(t.(Array).getElementType())
  ) and
  (
    not t.(Array).getElementType() instanceof BoxedType or
    isPrimitiveTypeUsedForBulkData(t.(Array).getElementType())
  ) and
  (
    not t.(CollectionType).getElementType() instanceof BoxedType or
    isPrimitiveTypeUsedForBulkData(t.(CollectionType).getElementType())
  )
}

predicate isRelevantTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(DataFlow::Content f |
    readStep(node1, f, node2) and
    if f instanceof DataFlow::FieldContent
    then isRelevantType(f.(DataFlow::FieldContent).getField().getType())
    else any()
  )
  or
  exists(DataFlow::Content f | storeStep(node1, f, node2) |
    f instanceof DataFlow::ArrayContent or
    f instanceof DataFlow::CollectionContent or
    f instanceof DataFlow::MapKeyContent or
    f instanceof DataFlow::MapValueContent
  )
}

string returnNodeAsOutput(TargetAPI api, ReturnNodeExt node) {
  if node.getKind() instanceof ValueReturnKind
  then result = "ReturnValue"
  else
    result = parameterAccess(api.getParameter(node.getKind().(ParamUpdateReturnKind).getPosition()))
}

string parameterAccess(Parameter p) {
  if
    p.getType() instanceof Array and
    not isPrimitiveTypeUsedForBulkData(p.getType().(Array).getElementType())
  then result = "ArrayElement of Argument[" + p.getPosition() + "]"
  else
    if p.getType() instanceof ContainerType
    then result = "Element of Argument[" + p.getPosition() + "]"
    else result = "Argument[" + p.getPosition() + "]"
}

predicate isPrimitiveTypeUsedForBulkData(Type t) {
  t.getName().regexpMatch("byte|char|Byte|Character")
}
