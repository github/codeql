import java
import semmle.code.java.dataflow.internal.DataFlowPrivate
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.internal.ContainerFlow
private import semmle.code.java.dataflow.internal.DataFlowImplCommon

Method superImpl(Method m) {
  result = m.getAnOverride() and
  not exists(result.getAnOverride()) and
  not m instanceof ToStringMethod
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

predicate isRelevantForModels(Callable api) {
  not isInTestFile(api.getCompilationUnit().getFile()) and
  not isJdkInternal(api.getCompilationUnit()) and
  not api instanceof MainMethod
}

/**
 * A class of Callables that are relevant for generating summary, source and sinks models for.
 *
 * In the Standard library and 3rd party libraries it the Callables that can be called
 * from outside the library itself.
 */
class TargetApi extends Callable {
  TargetApi() {
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

private string typeAsModel(RefType type) {
  result = type.getCompilationUnit().getPackage().getName() + ";" + type.nestedName()
}

private RefType bestTypeForModel(TargetApi api) {
  if exists(superImpl(api))
  then superImpl(api).fromSource() and result = superImpl(api).getDeclaringType()
  else result = api.getDeclaringType()
}

/**
 * Returns the appropriate type name for the model. Either the type
 * declaring the method or the supertype introducing the method.
 */
private string typeAsSummaryModel(TargetApi api) { result = typeAsModel(bestTypeForModel(api)) }

/**
 * Computes the first 6 columns for CSV rows.
 */
string asPartialModel(TargetApi api) {
  result =
    typeAsSummaryModel(api) + ";" //
      + isExtensible(bestTypeForModel(api)) + ";" //
      + api.getName() + ";" //
      + paramsString(api) + ";" //
      + /* ext + */ ";" //
}

private predicate isPrimitiveTypeUsedForBulkData(Type t) {
  t.getName().regexpMatch("byte|char|Byte|Character")
}

/**
 * Holds for type `t` for fields that are relevant as an intermediate
 * read or write step in the data flow analysis.
 */
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

private string parameterAccess(Parameter p) {
  if
    p.getType() instanceof Array and
    not isPrimitiveTypeUsedForBulkData(p.getType().(Array).getElementType())
  then result = "Argument[" + p.getPosition() + "].ArrayElement"
  else
    if p.getType() instanceof ContainerType
    then result = "Argument[" + p.getPosition() + "].Element"
    else result = "Argument[" + p.getPosition() + "]"
}

/**
 * Gets the model string representation of the parameter node `p`.
 */
string parameterNodeAsInput(DataFlow::ParameterNode p) {
  result = parameterAccess(p.asParameter())
  or
  result = "Argument[-1]" and p instanceof DataFlow::InstanceParameterNode
}

/**
 * Gets the model string represention of the the return node `node`.
 */
string returnNodeAsOutput(ReturnNodeExt node) {
  if node.getKind() instanceof ValueReturnKind
  then result = "ReturnValue"
  else
    exists(int pos | pos = node.getKind().(ParamUpdateReturnKind).getPosition() |
      result = parameterAccess(node.getEnclosingCallable().getParameter(pos))
      or
      result = "Argument[-1]" and pos = -1
    )
}
