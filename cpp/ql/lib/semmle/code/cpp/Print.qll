import cpp
private import PrintAST

/**
 * Print function declarations only if there is a `PrintASTConfiguration`
 * that requests that function, or no `PrintASTConfiguration` exists.
 */
private predicate shouldPrintDeclaration(Declaration decl) {
  not (decl instanceof Function or decl instanceof GlobalOrNamespaceVariable)
  or
  exists(PrintAstConfiguration config | config.shouldPrintDeclaration(decl))
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
  decl instanceof TypeTemplateParameter and result = ""
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
private class DumpDeclaration extends Declaration {
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
      this.getTypeSpecifier() + this.getDeclaratorPrefix() +
        this.getDeclaratorSuffixBeforeQualifiers() + this.getDeclaratorSuffix()
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
  override string getTypeSpecifier() { result = this.toString() }
}

private class IntegralDumpType extends BuiltInDumpType, IntegralType {
  override string getTypeSpecifier() { result = this.getCanonicalArithmeticType().toString() }
}

private class DerivedDumpType extends DumpType, DerivedType {
  override string getTypeSpecifier() { result = this.getBaseType().(DumpType).getTypeSpecifier() }

  override string getDeclaratorSuffixBeforeQualifiers() {
    result = this.getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers()
  }

  override string getDeclaratorSuffix() {
    result = this.getBaseType().(DumpType).getDeclaratorSuffix()
  }
}

private class DecltypeDumpType extends DumpType, Decltype {
  override string getTypeSpecifier() { result = this.getBaseType().(DumpType).getTypeSpecifier() }

  override string getDeclaratorPrefix() {
    result = this.getBaseType().(DumpType).getDeclaratorPrefix()
  }

  override string getDeclaratorSuffix() {
    result = this.getBaseType().(DumpType).getDeclaratorSuffix()
  }
}

private class PointerIshDumpType extends DerivedDumpType {
  PointerIshDumpType() {
    this instanceof PointerType or
    this instanceof ReferenceType
  }

  override string getDeclaratorPrefix() {
    exists(string declarator |
      result = this.getBaseType().(DumpType).getDeclaratorPrefix() + declarator and
      if this.getBaseType().getUnspecifiedType() instanceof ArrayType
      then declarator = "(" + this.getDeclaratorToken() + ")"
      else declarator = this.getDeclaratorToken()
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
  override string getTypeSpecifier() { result = this.getBaseType().(DumpType).getTypeSpecifier() }

  override string getDeclaratorPrefix() {
    exists(string declarator, string parenDeclarator, Type baseType |
      declarator = this.getClass().(DumpType).getTypeIdentityString() + "::*" and
      result = this.getBaseType().(DumpType).getDeclaratorPrefix() + " " + parenDeclarator and
      baseType = this.getBaseType().getUnspecifiedType() and
      if baseType instanceof ArrayType or baseType instanceof RoutineType
      then parenDeclarator = "(" + declarator
      else parenDeclarator = declarator
    )
  }

  override string getDeclaratorSuffixBeforeQualifiers() {
    exists(Type baseType |
      baseType = this.getBaseType().getUnspecifiedType() and
      if baseType instanceof ArrayType or baseType instanceof RoutineType
      then result = ")" + this.getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers()
      else result = this.getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers()
    )
  }

  override string getDeclaratorSuffix() {
    result = this.getBaseType().(DumpType).getDeclaratorSuffix()
  }
}

private class ArrayDumpType extends DerivedDumpType, ArrayType {
  override string getDeclaratorPrefix() {
    result = this.getBaseType().(DumpType).getDeclaratorPrefix()
  }

  override string getDeclaratorSuffixBeforeQualifiers() {
    if exists(this.getArraySize())
    then
      result =
        "[" + this.getArraySize().toString() + "]" +
          this.getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers()
    else result = "[]" + this.getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers()
  }
}

private class FunctionPointerIshDumpType extends DerivedDumpType, FunctionPointerIshType {
  override string getDeclaratorSuffixBeforeQualifiers() {
    result = ")" + this.getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers()
  }

  override string getDeclaratorSuffix() {
    result = this.getBaseType().(DumpType).getDeclaratorSuffix()
  }

  override string getDeclaratorPrefix() {
    result = this.getBaseType().(DumpType).getDeclaratorPrefix() + "(" + this.getDeclaratorToken()
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
  override string getTypeSpecifier() { result = this.getReturnType().(DumpType).getTypeSpecifier() }

  override string getDeclaratorPrefix() {
    result = this.getReturnType().(DumpType).getDeclaratorPrefix()
  }

  language[monotonicAggregates]
  override string getDeclaratorSuffixBeforeQualifiers() {
    result =
      "(" +
        concat(int i |
          exists(this.getParameterType(i))
        |
          getParameterTypeString(this.getParameterType(i)), ", " order by i
        ) + ")"
  }

  override string getDeclaratorSuffix() {
    result =
      this.getReturnType().(DumpType).getDeclaratorSuffixBeforeQualifiers() +
        this.getReturnType().(DumpType).getDeclaratorSuffix()
  }
}

private class SpecifiedDumpType extends DerivedDumpType, SpecifiedType {
  override string getDeclaratorPrefix() {
    exists(string basePrefix |
      basePrefix = this.getBaseType().(DumpType).getDeclaratorPrefix() and
      if this.getBaseType().getUnspecifiedType() instanceof RoutineType
      then result = basePrefix
      else result = basePrefix + " " + this.getSpecifierString()
    )
  }

  override string getDeclaratorSuffixBeforeQualifiers() {
    exists(string baseSuffix |
      baseSuffix = this.getBaseType().(DumpType).getDeclaratorSuffixBeforeQualifiers() and
      if this.getBaseType().getUnspecifiedType() instanceof RoutineType
      then result = baseSuffix + " " + this.getSpecifierString()
      else result = baseSuffix
    )
  }

  override string getDeclaratorSuffix() {
    result = this.getBaseType().(DumpType).getDeclaratorSuffix()
  }
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
          simpleName = "(" + min(this.getSimpleName()) + ")"
        else simpleName = this.getSimpleName()
      ) and
      result = getScopePrefix(this) + simpleName + this.getTemplateArgumentsString()
    )
  }

  override string getTypeSpecifier() { result = this.getIdentityString() }
}

private class DumpProxyClass extends UserDumpType, ProxyClass {
  override string getIdentityString() { result = this.getName() }
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
      this.getType().(DumpType).getTypeSpecifier() + this.getType().(DumpType).getDeclaratorPrefix()
        + " " + getScopePrefix(this) + this.getName() + this.getTemplateArgumentsString() +
        this.getDeclaratorSuffixBeforeQualifiers() + this.getDeclaratorSuffix()
  }

  language[monotonicAggregates]
  private string getDeclaratorSuffixBeforeQualifiers() {
    result =
      "(" +
        concat(int i |
          exists(this.getParameter(i).getType())
        |
          getParameterTypeString(this.getParameter(i).getType()), ", " order by i
        ) + ")" + this.getQualifierString()
  }

  private string getQualifierString() {
    if exists(this.getACVQualifier())
    then
      result =
        " " + strictconcat(string qualifier | qualifier = this.getACVQualifier() | qualifier, " ")
    else result = ""
  }

  private string getACVQualifier() {
    result = this.getASpecifier().getName() and
    result = ["const", "volatile"]
  }

  private string getDeclaratorSuffix() {
    result =
      this.getType().(DumpType).getDeclaratorSuffixBeforeQualifiers() +
        this.getType().(DumpType).getDeclaratorSuffix()
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
