/**
 * Provides the `Attribute` class.
 */

import Type
private import semmle.code.csharp.ExprOrStmtParent
private import TypeRef

/**
 * An element that can have attributes. Either an assembly (`Assembly`), a field (`Field`),
 * a parameter (`Parameter`), an operator (`Operator`), a method (`Method`), a constructor (`Constructor`),
 * a destructor (`Destructor`), a callable accessor (`CallableAccessor`), a value or reference type
 * (`ValueOrRefType`), a declaration with accessors (`DeclarationWithAccessors`), a local function
 * (`LocalFunction`) or a lambda expression (`LambdaExp`).
 */
class Attributable extends @attributable {
  /** Gets an attribute attached to this element, if any. */
  final Attribute getAnAttribute() { result.getTarget() = this }

  /** Gets a textual representation of this element. */
  string toString() { none() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.(Element)
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private string getAttributeName(Attribute a) {
  exists(string type, string pattern |
    type = a.getType().getName() and pattern = "(.*)Attribute(<.*>)?"
  |
    type.regexpMatch(pattern) and
    result = concat(int i | i = [1, 2] | type.regexpCapture(pattern, i) order by i)
    or
    not type.regexpMatch(pattern) and
    result = type
  )
}

/**
 * An attribute, for example `[...]` on line 1 in
 *
 * ```csharp
 * [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
 * public static extern int GetFinalPathNameByHandle(
 *   SafeHandle handle,
 *   [In, Out] StringBuilder path,
 *   int bufLen,
 *   int flags);
 * ```
 */
class Attribute extends TopLevelExprParent, @attribute {
  /** Gets the type of this attribute. */
  Class getType() {
    attributes(this, _, result, _)
    or
    not attributes(this, _, any(Type t), _) and
    attributes(this, _, getTypeRef(result), _)
  }

  /** Gets the namespace containing the attribute type declaration. */
  Namespace getNamespace() { result = this.getType().getNamespace() }

  /** Gets the element that this attribute is attached to. */
  Attributable getTarget() { attributes(this, _, _, result) }

  /**
   * Gets the `i`th argument of this attribute. This includes both constructor
   * arguments and named arguments.
   */
  Expr getArgument(int i) { result = this.getChildExpr(i) }

  /**
   * Gets the `i`th constructor argument of this attribute. For example, only
   * `true` is a constructor argument in
   *
   * ```csharp
   * MyAttribute[true, Foo = 0]
   * ```
   */
  Expr getConstructorArgument(int i) {
    result = this.getArgument(i) and not exists(result.getExplicitArgumentName())
  }

  /**
   * Gets the named argument `name` of this attribute. For example, only
   * `0` is a named argument in
   *
   * ```csharp
   * MyAttribute[true, Foo = 0]
   * ```
   */
  Expr getNamedArgument(string name) {
    result = this.getArgument(_) and
    result.getExplicitArgumentName() = name
  }

  override Location getALocation() { attribute_location(this, result) }

  override string toString() { result = "[" + getAttributeName(this) + "(...)]" }

  override string getAPrimaryQlClass() { result = "Attribute" }
}

/**
 * A generic attribute, for example `[...]` on line 1 in
 *
 * ```csharp
 * [MyGenericAttribute<int>(0)]
 * public void SomeMethod(string s) { }
 * ```
 */
class GenericAttribute extends Attribute {
  private ConstructedClass type;

  GenericAttribute() { type = this.getType() }

  /** Gets the total number of type arguments. */
  int getNumberOfTypeArguments() { result = count(int i | type_arguments(_, i, type)) }

  /** Gets the `i`th type argument, if any. */
  Type getTypeArgument(int i) { result = type.getTypeArgument(i) }

  /** Get a type argument. */
  Type getATypeArgument() { result = this.getTypeArgument(_) }

  override string getAPrimaryQlClass() { result = "GenericAttribute" }
}

/**
 * An attribute with default kind, for example `[...]` on line 1 in
 * ```csharp
 * [MyAttribute(0)]
 * int SomeMethod() { return 1; }
 * ```
 */
class DefaultAttribute extends Attribute, @attribute_default {
  override string getAPrimaryQlClass() { result = "DefaultAttribute" }
}

/**
 * A generic attribute with default kind, for example `[...]` on line 1 in
 * ```csharp
 * [MyAttribute<string>(0)]
 * int SomeMethod() { return 1; }
 * ```
 */
class GenericDefaultAttribute extends GenericAttribute, DefaultAttribute {
  override string getAPrimaryQlClass() { result = "GenericDefaultAttribute" }
}

/**
 * An attribute with return kind, for example `[...]` on line 1 in
 * ```csharp
 * [return: MyAttribute(0)]
 * int SomeMethod() { return 1; }
 * ```
 */
class ReturnAttribute extends Attribute, @attribute_return {
  override string toString() { result = "[return: " + getAttributeName(this) + "(...)]" }

  override string getAPrimaryQlClass() { result = "ReturnAttribute" }
}

/**
 * A generic attribute with return kind, for example `[...]` on line 1 in
 * ```csharp
 * [return: MyAttribute<object>(0)]
 * int SomeMethod() { return 1; }
 * ```
 */
class GenericReturnAttribute extends GenericAttribute, ReturnAttribute {
  override string getAPrimaryQlClass() { result = "GenericReturnAttribute" }
}

/**
 * An attribute with assembly kind, for example `[...]` on line 1 in
 * ```csharp
 * [assembly: MyAttribute(0)]
 * ```
 */
class AssemblyAttribute extends Attribute, @attribute_assembly {
  override string toString() { result = "[assembly: " + getAttributeName(this) + "(...)]" }

  override string getAPrimaryQlClass() { result = "AssemblyAttribute" }
}

/**
 * A generic attribute with assembly kind, for example `[...]` on line 1 in
 * ```csharp
 * [assembly: MyAttribute<string>(0)]
 * ```
 */
class GenericAssemblyAttribute extends GenericAttribute, AssemblyAttribute {
  override string getAPrimaryQlClass() { result = "GenericAssemblyAttribute" }
}

/**
 * An attribute with module kind, for example `[...]` on line 1 in
 * ```csharp
 * [module: MyAttribute(0)]
 * ```
 */
class ModuleAttribute extends Attribute, @attribute_module {
  override string toString() { result = "[module: " + getAttributeName(this) + "(...)]" }

  override string getAPrimaryQlClass() { result = "ModuleAttribute" }
}

/**
 * A generic attribute with module kind, for example `[...]` on line 1 in
 * ```csharp
 * [module: MyAttribute<string>(0)]
 * ```
 */
class GenericModuleAttribute extends GenericAttribute, ModuleAttribute {
  override string getAPrimaryQlClass() { result = "GenericModuleAttribute" }
}
