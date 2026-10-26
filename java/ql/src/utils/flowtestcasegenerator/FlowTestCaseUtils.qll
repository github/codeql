/**
 * Utility predicates useful for test generation.
 */

import java
private import semmle.code.java.dataflow.internal.DataFlowUtil
private import semmle.code.java.dataflow.FlowSummary
private import FlowTestCase

/**
 * Returns `t`'s outermost enclosing type, in raw form (i.e. generic types are given without generic parameters, and type variables are replaced by their bounds).
 */
Type getRootSourceDeclaration(Type t) {
  if t instanceof RefType
  then result = getRootType(replaceTypeVariable(t)).(RefType).getSourceDeclaration()
  else result = t
}

/**
 * Holds if type `t` does not clash with another type we want to import that has the same base name.
 */
predicate isImportable(Type t) {
  t = any(TestCase tc).getADesiredImport() and
  t =
    unique(Type sharesBaseName |
      sharesBaseName = any(TestCase tc).getADesiredImport() and
      sharesBaseName.getName() = t.getName()
    |
      sharesBaseName
    )
}

/**
 * Returns `t`'s first upper bound if `t` is a type variable; otherwise returns `t`.
 */
RefType replaceTypeVariable(RefType t) {
  if t instanceof TypeVariable
  then result = replaceTypeVariable(t.(TypeVariable).getFirstUpperBoundType())
  else result = t
}

/**
 * Returns a zero value of primitive type `t`.
 */
string getZero(PrimitiveType t) {
  t.hasName("float") and result = "0.0f"
  or
  t.hasName("double") and result = "0.0"
  or
  t.hasName("int") and result = "0"
  or
  t.hasName("boolean") and result = "false"
  or
  t.hasName("short") and result = "(short)0"
  or
  t.hasName("byte") and result = "(byte)0"
  or
  t.hasName("char") and result = "'\\0'"
  or
  t.hasName("long") and result = "0L"
}

/**
 * Holds if `c` may require disambiguation from an overload with the same argument count.
 */
predicate mayBeAmbiguous(Callable c) {
  exists(Callable other, Callable override, string package, string type, string name |
    override = [c, c.(Method).getASourceOverriddenMethod*()] and
    override.hasQualifiedName(package, type, name) and
    other.hasQualifiedName(package, type, name) and
    other.getNumberOfParameters() = override.getNumberOfParameters() and
    other != override
  )
  or
  c.isVarargs()
}

/**
 * Returns the outermost type enclosing type `t` (which may be `t` itself).
 */
Type getRootType(Type t) {
  if t instanceof NestedType
  then result = getRootType(t.(NestedType).getEnclosingType())
  else
    if t instanceof Array
    then result = getRootType(t.(Array).getElementType())
    else result = t
}

/**
 * Returns a printable name for type `t`, stripped of generics and, if a type variable,
 * replaced by its bound. Usually this is a short name, but it may be package-qualified
 * if we cannot import it due to a name clash.
 */
string getShortNameIfPossible(Type t) {
  if t instanceof Array
  then result = getShortNameIfPossible(t.(Array).getComponentType()) + "[]"
  else (
    if t instanceof RefType
    then
      getRootSourceDeclaration(t) = any(TestCase tc).getADesiredImport() and
      exists(RefType replaced, string nestedName |
        replaced = replaceTypeVariable(t).getSourceDeclaration() and
        nestedName = replaced.getNestedName().replaceAll("$", ".")
      |
        if isImportable(getRootSourceDeclaration(t))
        then result = nestedName
        else result = replaced.getPackage().getName() + "." + nestedName
      )
    else result = t.getName()
  )
}

/**
 * Gets a string that specifies summary component `c` in a summary specification CSV row.
 */
string getComponentSpec(SummaryComponent c) {
  exists(Content content |
    c = SummaryComponent::content(content) and
    (
      content instanceof ArrayContent and result = "ArrayElement"
      or
      content instanceof MapValueContent and result = "MapValue"
      or
      content instanceof MapKeyContent and result = "MapKey"
      or
      content instanceof CollectionContent and result = "Element"
      or
      result = "Field[" + content.(FieldContent).getField().getQualifiedName() + "]"
      or
      result = "SyntheticField[" + content.(SyntheticFieldContent).getField() + "]"
    )
  )
}
