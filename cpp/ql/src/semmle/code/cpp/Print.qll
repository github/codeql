import cpp
private import PrintAST

/**
 * Print function declarations only if there is a `PrintASTConfiguration`
 * that requests that function, or no `PrintASTConfiguration` exists.
 */
private predicate shouldPrintDeclaration(Declaration decl) {
  not decl instanceof Function
  or
  not exists(PrintASTConfiguration c)
  or
  exists(PrintASTConfiguration config | config.shouldPrintFunction(decl))
}

/**
 * Gets a string containing the scope in which this declaration is declared.
 */
private string getScopePrefix(Declaration decl) {
  decl.isMember() and result = decl.getDeclaringType().(UserDumpType).getIdentityString() + "::"
  or
  decl.isTopLevel() and
  exists(string parentName |
    parentName = decl.getNamespace().getQualifiedName() and
    (
      parentName != "" and result = parentName + "::"
      or
      parentName = "" and result = ""
    )
  )
  or
  exists(UserType type |
    type = decl and
    type.isLocal() and
    result = "(" + type.getEnclosingFunction().(DumpFunction).getIdentityString() + ")::"
  )
  or
  decl instanceof TemplateParameter and result = ""
}

/**
 * Gets the identity string of a type used as a parameter. Identical to `Type.getTypeIdentityString()`, except that
 * it returns `...` for `UnknownType`, which is used to represent variable arguments.
 */
private string getParameterTypeString(Type parameterType) {
  if parameterType instanceof UnknownType
  then result = "..."
  else result = parameterType.(DumpType).getTypeIdentityString()
}

private string getTemplateArgumentString(Declaration d, int i) {
  if exists(d.getTemplateArgumentKind(i))
  then
    result =
      d.getTemplateArgumentKind(i).(DumpType).getTypeIdentityString() + " " +
        d.getTemplateArgument(i)
  else result = d.getTemplateArgument(i).(DumpType).getTypeIdentityString()
}

/**
 * A `Declaration` extended to add methods for generating strings useful only for dumps and debugging.
 */
abstract private class DumpDeclaration extends Declaration {
  DumpDeclaration() { shouldPrintDeclaration(this) }

  /**
   * Gets a string that uniquely identifies this declaration, suitable for use when debugging queries. Only holds for
   * functions, user-defined types, global and namespace-scope variables, and member variables.
   *
   * This operation is very expensive, and should not be used in production queries. Consider using
   * `hasQualifiedName()` for identifying known declarations in production queries.
   */
  string getIdentityString() { none() }

  language[monotonicAggregates]
  final string getTemplateArgumentsString() {
    if exists(this.getATemplateArgument())
    then
      result =
        "<" +
          strictconcat(int i |
            exists(this.getTemplateArgument(i))
          |
            getTemplateArgumentString(this, i), ", " order by i
          ) + ">"
    else result = ""
  }
}

/**
 * A `Type` extended to add methods for generating strings useful only for dumps and debugging.
 */
private class DumpType extends Type {
  /**
   * Gets a string that uniquely identifies this type, suitable for use when debugging queries. All typedefs and
   * decltypes are expanded, and all symbol names are fully qualified.
   *
   * This operation is very expensive, and should not be used in production queries.
   */
  final string getTypeIdentityString() {
    // The identity string of a type is just the concatenation of the four
    // components below. To create the type identity for a derived type, insert
    // the declarator of the derived type between the `getDeclaratorPrefix()`
    // and `getDeclaratorSuffixBeforeQualifiers()`. To create the type identity
    // for a `SpecifiedType`, insert the qualifiers after
    // `getDeclaratorSuffixBeforeQualifiers()`.
    result =
      getTypeSpecifier() + getDeclaratorPrefix() + getDeclaratorSuffixBeforeQualifiers() +
        getDeclaratorSuffix()
  }

  /**
   * Gets the "type specifier" part of this type's name. This is generally the "leaf" type from which the type was
   * constructed.
   *
   * Examples:
   * - `int` -> `int`
   * - `int*` -> `int`
   * - `int (*&)(float, double) const` -> `int`
   *
   * This predicate is intended to be used only by the implementation of `getTypeIdentityString`.
   */
  string getTypeSpecifier() { result = "" }

  /**
   * Gets the portion of this type's declarator that comes before the declarator for any derived type.
   *
   * This predicate is intended to be used only by the implementation of `getTypeIdentityString`.
   */
  string getDeclaratorPrefix() { result = "" }

  /**
   * Gets the portion of this type's declarator that comes after the declarator for any derived type, but before any
   * qualifiers on the current type.
   *
   * This predicate is intended to be used only by the implementation of `getTypeIdentityString`.
   */
  string getDeclaratorSuffixBeforeQualifiers() { result = "" }

  /**
   * Gets the portion of this type's declarator that comes after the declarator for any derived type and after any
   * qualifiers on the current type.
   *
   * This predicate is intended to be used only by the implementation of `getTypeIdentityString`.
   */
  string getDeclaratorSuffix() { result = "" }
}

private class BuiltInDumpType extends DumpType, BuiltInType {
  override string getTypeSpecifier() { result = toString() }
}

private class IntegralDumpType extends BuiltInDumpType, IntegralType {
  override string getTypeSpecifier() { result = getCanonicalArithmeticType().toString() }
}

private class DerivedDumpType extends DumpType, DerivedType {
  override string getTypeSpecifier() { result = getBaseType().(DumpType).getTypeSpecifier() }

  override string getDeclaratorSuffixBeforeQualifiers() {
    result = getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers()
  }

  override string getDeclaratorSuffix() { result = getBaseType().(DumpType).getDeclaratorSuffix() }
}

private class DecltypeDumpType extends DumpType, Decltype {
  override string getTypeSpecifier() { result = getBaseType().(DumpType).getTypeSpecifier() }

  override string getDeclaratorPrefix() { result = getBaseType().(DumpType).getDeclaratorPrefix() }

  override string getDeclaratorSuffix() { result = getBaseType().(DumpType).getDeclaratorSuffix() }
}

private class PointerIshDumpType extends DerivedDumpType {
  PointerIshDumpType() {
    this instanceof PointerType or
    this instanceof ReferenceType
  }

  override string getDeclaratorPrefix() {
    exists(string declarator |
      result = getBaseType().(DumpType).getDeclaratorPrefix() + declarator and
      if getBaseType().getUnspecifiedType() instanceof ArrayType
      then declarator = "(" + getDeclaratorToken() + ")"
      else declarator = getDeclaratorToken()
    )
  }

  /**
   * Gets the token used when declaring this kind of type (e.g. `*`, `&`, `&&`)/
   */
  string getDeclaratorToken() { result = "" }
}

private class PointerDumpType extends PointerIshDumpType, PointerType {
  override string getDeclaratorToken() { result = "*" }
}

private class LValueReferenceDumpType extends PointerIshDumpType, LValueReferenceType {
  override string getDeclaratorToken() { result = "&" }
}

private class RValueReferenceDumpType extends PointerIshDumpType, RValueReferenceType {
  override string getDeclaratorToken() { result = "&&" }
}

private class PointerToMemberDumpType extends DumpType, PointerToMemberType {
  override string getTypeSpecifier() { result = getBaseType().(DumpType).getTypeSpecifier() }

  override string getDeclaratorPrefix() {
    exists(string declarator, string parenDeclarator, Type baseType |
      declarator = getClass().(DumpType).getTypeIdentityString() + "::*" and
      result = getBaseType().(DumpType).getDeclaratorPrefix() + " " + parenDeclarator and
      baseType = getBaseType().getUnspecifiedType() and
      if baseType instanceof ArrayType or baseType instanceof RoutineType
      then parenDeclarator = "(" + declarator
      else parenDeclarator = declarator
    )
  }

  override string getDeclaratorSuffixBeforeQualifiers() {
    exists(Type baseType |
      baseType = getBaseType().getUnspecifiedType() and
      if baseType instanceof ArrayType or baseType instanceof RoutineType
      then result = ")" + getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers()
      else result = getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers()
    )
  }

  override string getDeclaratorSuffix() { result = getBaseType().(DumpType).getDeclaratorSuffix() }
}

private class ArrayDumpType extends DerivedDumpType, ArrayType {
  override string getDeclaratorPrefix() { result = getBaseType().(DumpType).getDeclaratorPrefix() }

  override string getDeclaratorSuffixBeforeQualifiers() {
    if exists(getArraySize())
    then
      result =
        "[" + getArraySize().toString() + "]" +
          getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers()
    else result = "[]" + getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers()
  }
}

private class FunctionPointerIshDumpType extends DerivedDumpType, FunctionPointerIshType {
  override string getDeclaratorSuffixBeforeQualifiers() {
    result = ")" + getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers()
  }

  override string getDeclaratorSuffix() { result = getBaseType().(DumpType).getDeclaratorSuffix() }

  override string getDeclaratorPrefix() {
    result = getBaseType().(DumpType).getDeclaratorPrefix() + "(" + getDeclaratorToken()
  }

  /**
   * Gets the token used when declaring this kind of type (e.g. `*`, `&`, `^`)/
   */
  string getDeclaratorToken() { result = "" }
}

private class FunctionPointerDumpType extends FunctionPointerIshDumpType, FunctionPointerType {
  override string getDeclaratorToken() { result = "*" }
}

private class FunctionReferenceDumpType extends FunctionPointerIshDumpType, FunctionReferenceType {
  override string getDeclaratorToken() { result = "&" }
}

private class BlockDumpType extends FunctionPointerIshDumpType, BlockType {
  override string getDeclaratorToken() { result = "^" }
}

private class RoutineDumpType extends DumpType, RoutineType {
  override string getTypeSpecifier() { result = getReturnType().(DumpType).getTypeSpecifier() }

  override string getDeclaratorPrefix() {
    result = getReturnType().(DumpType).getDeclaratorPrefix()
  }

  language[monotonicAggregates]
  override string getDeclaratorSuffixBeforeQualifiers() {
    result =
      "(" +
        concat(int i |
          exists(getParameterType(i))
        |
          getParameterTypeString(getParameterType(i)), ", " order by i
        ) + ")"
  }

  override string getDeclaratorSuffix() {
    result =
      getReturnType().(DumpType).getDeclaratorSuffixBeforeQualifiers() +
        getReturnType().(DumpType).getDeclaratorSuffix()
  }
}

private class SpecifiedDumpType extends DerivedDumpType, SpecifiedType {
  override string getDeclaratorPrefix() {
    exists(string basePrefix |
      basePrefix = getBaseType().(DumpType).getDeclaratorPrefix() and
      if getBaseType().getUnspecifiedType() instanceof RoutineType
      then result = basePrefix
      else result = basePrefix + " " + getSpecifierString()
    )
  }

  override string getDeclaratorSuffixBeforeQualifiers() {
    exists(string baseSuffix |
      baseSuffix = getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers() and
      if getBaseType().getUnspecifiedType() instanceof RoutineType
      then result = baseSuffix + " " + getSpecifierString()
      else result = baseSuffix
    )
  }

  override string getDeclaratorSuffix() { result = getBaseType().(DumpType).getDeclaratorSuffix() }
}

private class UserDumpType extends DumpType, DumpDeclaration, UserType {
  override string getIdentityString() {
    exists(string simpleName |
      (
        if this instanceof Closure
        then
          // Parenthesize the name of the lambda because it's freeform text similar to
          // "lambda [] type at line 12, col. 40"
          // Use `min(getSimpleName())` to work around an extractor bug where a lambda can have different names
          // from different compilation units.
          simpleName = "(" + min(getSimpleName()) + ")"
        else simpleName = getSimpleName()
      ) and
      result = getScopePrefix(this) + simpleName + getTemplateArgumentsString()
    )
  }

  override string getTypeSpecifier() { result = getIdentityString() }
}

private class DumpProxyClass extends UserDumpType, ProxyClass {
  override string getIdentityString() { result = getName() }
}

private class DumpVariable extends DumpDeclaration, Variable {
  override string getIdentityString() {
    exists(DumpType type |
      (this instanceof MemberVariable or this instanceof GlobalOrNamespaceVariable) and
      type = this.getType() and
      result =
        type.getTypeSpecifier() + type.getDeclaratorPrefix() + " " + getScopePrefix(this) +
          this.getName() + this.getTemplateArgumentsString() +
          type.getDeclaratorSuffixBeforeQualifiers() + type.getDeclaratorSuffix()
    )
  }
}

private class DumpFunction extends DumpDeclaration, Function {
  override string getIdentityString() {
    result =
      getType().(DumpType).getTypeSpecifier() + getType().(DumpType).getDeclaratorPrefix() + " " +
        getScopePrefix(this) + getName() + getTemplateArgumentsString() +
        getDeclaratorSuffixBeforeQualifiers() + getDeclaratorSuffix()
  }

  language[monotonicAggregates]
  private string getDeclaratorSuffixBeforeQualifiers() {
    result =
      "(" +
        concat(int i |
          exists(getParameter(i).getType())
        |
          getParameterTypeString(getParameter(i).getType()), ", " order by i
        ) + ")" + getQualifierString()
  }

  private string getQualifierString() {
    if exists(getACVQualifier())
    then
      result = " " + strictconcat(string qualifier | qualifier = getACVQualifier() | qualifier, " ")
    else result = ""
  }

  private string getACVQualifier() {
    result = getASpecifier().getName() and
    (result = "const" or result = "volatile")
  }

  private string getDeclaratorSuffix() {
    result =
      getType().(DumpType).getDeclaratorSuffixBeforeQualifiers() +
        getType().(DumpType).getDeclaratorSuffix()
  }
}

/**
 * Gets a string that uniquely identifies this declaration, suitable for use when debugging queries. Only holds for
 * functions, user-defined types, global and namespace-scope variables, and member variables.
 *
 * This operation is very expensive, and should not be used in production queries. Consider using `hasName()` or
 * `hasQualifiedName()` for identifying known declarations in production queries.
 */
string getIdentityString(Declaration decl) { result = decl.(DumpDeclaration).getIdentityString() }

/**
 * Gets a string that uniquely identifies this type, suitable for use when debugging queries. All typedefs and
 * decltypes are expanded, and all symbol names are fully qualified.
 *
 * This operation is very expensive, and should not be used in production queries.
 */
string getTypeIdentityString(Type type) { result = type.(DumpType).getTypeIdentityString() }
