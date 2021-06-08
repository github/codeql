/**
 * Provides classes for modeling variables and their declarations.
 */

import semmle.code.cpp.Element
import semmle.code.cpp.exprs.Access
import semmle.code.cpp.Initializer
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ variable. For example, in the following code there are four
 * variables, `a`, `b`, `c` and `d`:
 * ```
 * extern int a;
 * int a;
 *
 * void myFunction(int b) {
 *   int c;
 * }
 *
 * namespace N {
 *   extern int d;
 *   int d = 1;
 * }
 * ```
 *
 * For local variables, there is a one-to-one correspondence between
 * `Variable` and `VariableDeclarationEntry`.
 *
 * For other types of variable, there is a one-to-many relationship between
 * `Variable` and `VariableDeclarationEntry`. For example, a `Parameter`
 * can have multiple declarations.
 */
class Variable extends Declaration, @variable {
  override string getAPrimaryQlClass() { result = "Variable" }

  /** Gets the initializer of this variable, if any. */
  Initializer getInitializer() { result.getDeclaration() = this }

  /** Holds if this variable has an initializer. */
  predicate hasInitializer() { exists(this.getInitializer()) }

  /** Gets an access to this variable. */
  VariableAccess getAnAccess() { result.getTarget() = this }

  /**
   * Gets a specifier of this variable. This includes `extern`, `static`,
   * `auto`, `private`, `protected`, `public`. Specifiers of the *type* of
   * this variable, such as `const` and `volatile`, are instead accessed
   * through `this.getType().getASpecifier()`.
   */
  override Specifier getASpecifier() {
    varspecifiers(underlyingElement(this), unresolveElement(result))
  }

  /** Gets an attribute of this variable. */
  Attribute getAnAttribute() { varattributes(underlyingElement(this), unresolveElement(result)) }

  /** Holds if this variable is `const`. */
  predicate isConst() { this.getType().isConst() }

  /** Holds if this variable is `volatile`. */
  predicate isVolatile() { this.getType().isVolatile() }

  /** Gets the name of this variable. */
  override string getName() { none() }

  /** Gets the type of this variable. */
  Type getType() { none() }

  /** Gets the type of this variable, after typedefs have been resolved. */
  Type getUnderlyingType() { result = this.getType().getUnderlyingType() }

  /**
   * Gets the type of this variable, after specifiers have been deeply
   * stripped and typedefs have been resolved.
   */
  Type getUnspecifiedType() { result = this.getType().getUnspecifiedType() }

  /**
   * Gets the type of this variable prior to deduction caused by the C++11
   * `auto` keyword.
   *
   * If the type of this variable was not declared with the C++11 `auto`
   * keyword, then this predicate does not hold.
   *
   * If the type of this variable is completely `auto`, then `result` is an
   * instance of `AutoType`. For example:
   *
   *   `auto four = 4;`
   *
   * If the type of this variable is partially `auto`, then a descendant of
   * `result` is an instance of `AutoType`. For example:
   *
   *   `const auto& c = container;`
   */
  Type getTypeWithAuto() { autoderivation(underlyingElement(this), unresolveElement(result)) }

  /**
   * Holds if the type of this variable is declared using the C++ `auto`
   * keyword.
   */
  predicate declaredUsingAutoType() { autoderivation(underlyingElement(this), _) }

  override VariableDeclarationEntry getADeclarationEntry() { result.getDeclaration() = this }

  override Location getADeclarationLocation() { result = getADeclarationEntry().getLocation() }

  override VariableDeclarationEntry getDefinition() {
    result = getADeclarationEntry() and
    result.isDefinition()
  }

  override Location getDefinitionLocation() { result = getDefinition().getLocation() }

  override Location getLocation() {
    if exists(getDefinition())
    then result = this.getDefinitionLocation()
    else result = this.getADeclarationLocation()
  }

  /**
   * Gets an expression that is assigned to this variable somewhere in the
   * program.
   */
  Expr getAnAssignedValue() {
    result = this.getInitializer().getExpr()
    or
    exists(ConstructorFieldInit cfi | cfi.getTarget() = this and result = cfi.getExpr())
    or
    exists(AssignExpr ae | ae.getLValue().(Access).getTarget() = this and result = ae.getRValue())
    or
    exists(ClassAggregateLiteral l | result = l.getFieldExpr(this))
  }

  /**
   * Gets an assignment expression that assigns to this variable.
   * For example: `x=...` or `x+=...`.
   */
  Assignment getAnAssignment() { result.getLValue() = this.getAnAccess() }

  /**
   * Holds if this variable is `constexpr`.
   */
  predicate isConstexpr() { this.hasSpecifier("is_constexpr") }

  /**
   * Holds if this variable is declared `constinit`.
   */
  predicate isConstinit() { this.hasSpecifier("declared_constinit") }

  /**
   * Holds if this variable is `thread_local`.
   */
  predicate isThreadLocal() { this.hasSpecifier("is_thread_local") }

  /**
   * Holds if this variable is constructed from `v` as a result
   * of template instantiation. If so, it originates either from a template
   * variable or from a variable nested in a template class.
   */
  predicate isConstructedFrom(Variable v) {
    variable_instantiation(underlyingElement(this), unresolveElement(v))
  }

  /**
   * Holds if this is a compiler-generated variable. For example, a
   * [range-based for loop](http://en.cppreference.com/w/cpp/language/range-for)
   * typically has three compiler-generated variables, named `__range`,
   * `__begin`, and `__end`:
   *
   *    `for (char c : str) { ... }`
   */
  predicate isCompilerGenerated() { compgenerated(underlyingElement(this)) }
}

/**
 * A particular declaration or definition of a C/C++ variable. For example, in
 * the following code there are six variable declaration entries - two each for
 * `a` and `d`, and one each for `b` and `c`:
 * ```
 * extern int a;
 * int a;
 *
 * void myFunction(int b) {
 *   int c;
 * }
 *
 * namespace N {
 *   extern int d;
 *   int d = 1;
 * }
 * ```
 */
class VariableDeclarationEntry extends DeclarationEntry, @var_decl {
  override Variable getDeclaration() { result = getVariable() }

  override string getAPrimaryQlClass() { result = "VariableDeclarationEntry" }

  /**
   * Gets the variable which is being declared or defined.
   */
  Variable getVariable() { var_decls(underlyingElement(this), unresolveElement(result), _, _, _) }

  /**
   * Gets the name, if any, used for the variable at this declaration or
   * definition.
   *
   * In most cases, this will be the name of the variable itself. The only
   * case in which it can differ is in a parameter declaration entry,
   * because the parameter may have a different name in the declaration
   * than in the definition. For example:
   *
   * ```
   * // Declaration. Parameter is named "x".
   * int f(int x);
   *
   * // Definition. Parameter is named "y".
   * int f(int y) { return y; }
   * ```
   */
  override string getName() { var_decls(underlyingElement(this), _, _, result, _) and result != "" }

  /**
   * Gets the type of the variable which is being declared or defined.
   */
  override Type getType() { var_decls(underlyingElement(this), _, unresolveElement(result), _, _) }

  override Location getLocation() { var_decls(underlyingElement(this), _, _, _, result) }

  /**
   * Holds if this is a definition of a variable.
   *
   * This always holds for local variables and member variables, but need
   * not hold for global variables. In the case of function parameters,
   * this holds precisely when the enclosing `FunctionDeclarationEntry` is
   * a definition.
   */
  override predicate isDefinition() { var_def(underlyingElement(this)) }

  override string getASpecifier() { var_decl_specifiers(underlyingElement(this), result) }
}

/**
 * A parameter as described within a particular declaration or definition
 * of a C/C++ function. For example the declaration of `a` in the following
 * code:
 * ```
 * void myFunction(int a) {
 *   int b;
 * }
 * ```
 */
class ParameterDeclarationEntry extends VariableDeclarationEntry {
  ParameterDeclarationEntry() { param_decl_bind(underlyingElement(this), _, _) }

  override string getAPrimaryQlClass() { result = "ParameterDeclarationEntry" }

  /**
   * Gets the function declaration or definition which this parameter
   * description is part of.
   */
  FunctionDeclarationEntry getFunctionDeclarationEntry() {
    param_decl_bind(underlyingElement(this), _, unresolveElement(result))
  }

  /**
   * Gets the zero-based index of this parameter.
   */
  int getIndex() { param_decl_bind(underlyingElement(this), result, _) }

  private string getAnonymousParameterDescription() {
    not exists(getName()) and
    exists(string idx |
      idx =
        ((getIndex() + 1).toString() + "th")
            .replaceAll("1th", "1st")
            .replaceAll("2th", "2nd")
            .replaceAll("3th", "3rd")
            .replaceAll("11st", "11th")
            .replaceAll("12nd", "12th")
            .replaceAll("13rd", "13th") and
      if exists(getCanonicalName())
      then result = "declaration of " + getCanonicalName() + " as anonymous " + idx + " parameter"
      else result = "declaration of " + idx + " parameter"
    )
  }

  override string toString() {
    isDefinition() and
    result = "definition of " + getName()
    or
    not isDefinition() and
    if getName() = getCanonicalName()
    then result = "declaration of " + getName()
    else result = "declaration of " + getCanonicalName() + " as " + getName()
    or
    result = getAnonymousParameterDescription()
  }

  /**
   * Gets the name of this `ParameterDeclarationEntry` including it's type.
   *
   * For example: "int p".
   */
  string getTypedName() {
    exists(string typeString, string nameString |
      (if exists(getType().getName()) then typeString = getType().getName() else typeString = "") and
      (if exists(getName()) then nameString = getName() else nameString = "") and
      if typeString != "" and nameString != ""
      then result = typeString + " " + nameString
      else result = typeString + nameString
    )
  }
}

/**
 * A C/C++ variable with block scope [N4140 3.3.3]. In other words, a local
 * variable or a function parameter. For example, the variables `a`, `b` and
 * `c` in the following code:
 * ```
 * void myFunction(int a) {
 *   int b;
 *   static int c;
 * }
 * ```
 *
 * See also `StackVariable`, which is the class of local-scope variables
 * without statics and thread-locals.
 */
class LocalScopeVariable extends Variable, @localscopevariable {
  /** Gets the function to which this variable belongs. */
  Function getFunction() { none() } // overridden in subclasses
}

/**
 * A C/C++ variable with _automatic storage duration_. In other words, a
 * function parameter or a local variable that is not static or thread-local.
 * For example, the variables `a` and `b` in the following code.
 * ```
 * void myFunction(int a) {
 *   int b;
 *   static int c;
 * }
 * ```
 */
class StackVariable extends LocalScopeVariable {
  StackVariable() {
    not this.isStatic() and
    not this.isThreadLocal()
  }
}

/**
 * A C/C++ local variable. In other words, any variable that has block
 * scope [N4140 3.3.3], but is not a parameter of a `Function` or `CatchBlock`.
 * For example the variables `b` and `c` in the following code:
 * ```
 * void myFunction(int a) {
 *   int b;
 *   static int c;
 * }
 * ```
 *
 * Local variables can be static; use the `isStatic` member predicate to detect
 * those.
 *
 * A local variable can be declared by a `DeclStmt` or a `ConditionDeclExpr`.
 */
class LocalVariable extends LocalScopeVariable, @localvariable {
  override string getAPrimaryQlClass() { result = "LocalVariable" }

  override string getName() { localvariables(underlyingElement(this), _, result) }

  override Type getType() { localvariables(underlyingElement(this), unresolveElement(result), _) }

  override Function getFunction() {
    exists(DeclStmt s | s.getADeclaration() = this and s.getEnclosingFunction() = result)
    or
    exists(ConditionDeclExpr e | e.getVariable() = this and e.getEnclosingFunction() = result)
  }
}

/**
 * A variable whose contents always have static storage duration. This can be a
 * global variable, a namespace variable, a static local variable, or a static
 * member variable.
 */
class StaticStorageDurationVariable extends Variable {
  StaticStorageDurationVariable() {
    this instanceof GlobalOrNamespaceVariable
    or
    this.(LocalVariable).isStatic()
    or
    this.(MemberVariable).isStatic()
  }

  /**
   * Holds if the initializer for this variable is evaluated at runtime.
   */
  predicate hasDynamicInitialization() {
    runtimeExprInStaticInitializer(this.getInitializer().getExpr())
  }
}

/**
 * Holds if `e` is an expression in a static initializer that must be evaluated
 * at run time. This predicate computes "is non-const" instead of "is const"
 * since computing "is const" for an aggregate literal with many children would
 * either involve recursion through `forall` on those children or an iteration
 * through the rank numbers of the children, both of which can be slow.
 */
private predicate runtimeExprInStaticInitializer(Expr e) {
  inStaticInitializer(e) and
  if e instanceof AggregateLiteral // in sync with the cast in `inStaticInitializer`
  then runtimeExprInStaticInitializer(e.getAChild())
  else not e.getFullyConverted().isConstant()
}

/**
 * Holds if `e` is the initializer of a `StaticStorageDurationVariable`, either
 * directly or below some top-level `AggregateLiteral`s.
 */
private predicate inStaticInitializer(Expr e) {
  exists(StaticStorageDurationVariable var | e = var.getInitializer().getExpr())
  or
  // The cast to `AggregateLiteral` ensures we only compute what'll later be
  // needed by `runtimeExprInStaticInitializer`.
  inStaticInitializer(e.getParent().(AggregateLiteral))
}

/**
 * A C++ local variable declared as `static`.
 */
class StaticLocalVariable extends LocalVariable, StaticStorageDurationVariable { }

/**
 * A C/C++ variable which has global scope or namespace scope. For example the
 * variables `a` and `b` in the following code:
 * ```
 * int a;
 *
 * namespace N {
 *   int b;
 * }
 * ```
 */
class GlobalOrNamespaceVariable extends Variable, @globalvariable {
  override string getName() { globalvariables(underlyingElement(this), _, result) }

  override Type getType() { globalvariables(underlyingElement(this), unresolveElement(result), _) }

  override Element getEnclosingElement() { none() }
}

/**
 * A C/C++ variable which has namespace scope. For example the variable `b`
 * in the following code:
 * ```
 * int a;
 *
 * namespace N {
 *   int b;
 * }
 * ```
 */
class NamespaceVariable extends GlobalOrNamespaceVariable {
  NamespaceVariable() {
    exists(Namespace n | namespacembrs(unresolveElement(n), underlyingElement(this)))
  }

  override string getAPrimaryQlClass() { result = "NamespaceVariable" }
}

/**
 * A C/C++ variable which has global scope. For example the variable `a`
 * in the following code:
 * ```
 * int a;
 *
 * namespace N {
 *   int b;
 * }
 * ```
 *
 * Note that variables declared in anonymous namespaces have namespace scope,
 * even though they are accessed in the same manner as variables declared in
 * the enclosing scope of said namespace (which may be the global scope).
 */
class GlobalVariable extends GlobalOrNamespaceVariable {
  GlobalVariable() { not this instanceof NamespaceVariable }

  override string getAPrimaryQlClass() { result = "GlobalVariable" }
}

/**
 * A C structure member or C++ member variable. For example the member
 * variables `m` and `s` in the following code:
 * ```
 * class MyClass {
 * public:
 *   int m;
 *   static int s;
 * };
 * ```
 *
 * This includes static member variables in C++. To exclude static member
 * variables, use `Field` instead of `MemberVariable`.
 */
class MemberVariable extends Variable, @membervariable {
  MemberVariable() { this.isMember() }

  override string getAPrimaryQlClass() { result = "MemberVariable" }

  /** Holds if this member is private. */
  predicate isPrivate() { this.hasSpecifier("private") }

  /** Holds if this member is protected. */
  predicate isProtected() { this.hasSpecifier("protected") }

  /** Holds if this member is public. */
  predicate isPublic() { this.hasSpecifier("public") }

  override string getName() { membervariables(underlyingElement(this), _, result) }

  override Type getType() {
    if strictcount(this.getAType()) = 1
    then result = this.getAType()
    else
      // In rare situations a member variable may have multiple types in
      // different translation units. In that case, we return the unspecified
      // type.
      result = this.getAType().getUnspecifiedType()
  }

  /** Holds if this member is mutable. */
  predicate isMutable() { getADeclarationEntry().hasSpecifier("mutable") }

  private Type getAType() { membervariables(underlyingElement(this), unresolveElement(result), _) }
}

/**
 * A C/C++ function pointer variable.
 *
 * DEPRECATED: use `Variable.getType() instanceof FunctionPointerType` instead.
 */
deprecated class FunctionPointerVariable extends Variable {
  FunctionPointerVariable() { this.getType() instanceof FunctionPointerType }
}

/**
 * A C/C++ function pointer member variable.
 *
 * DEPRECATED: use `MemberVariable.getType() instanceof FunctionPointerType` instead.
 */
deprecated class FunctionPointerMemberVariable extends MemberVariable {
  FunctionPointerMemberVariable() { this instanceof FunctionPointerVariable }
}

/**
 * A C++14 variable template. For example, in the following code the variable
 * template `v` defines a family of variables:
 * ```
 * template<class T>
 * T v;
 * ```
 */
class TemplateVariable extends Variable {
  TemplateVariable() { is_variable_template(underlyingElement(this)) }

  /**
   * Gets an instantiation of this variable template.
   */
  Variable getAnInstantiation() { result.isConstructedFrom(this) }
}

/**
 * A non-static local variable or parameter that is not part of an
 * uninstantiated template. Uninstantiated templates are purely syntax, and
 * only on instantiation will they be complete with information about types,
 * conversions, call targets, etc. For example in the following code, the
 * variables `a` in `myFunction` and `b` in the instantiation
 * `myTemplateFunction<int>`, but not `b` in the template
 * `myTemplateFunction<T>`:
 * ```
 * void myFunction() {
 *   float a;
 * }
 *
 * template<typename T>
 * void myTemplateFunction() {
 *   T b;
 * }
 *
 * ...
 *
 * myTemplateFunction<int>();
 * ```
 */
class SemanticStackVariable extends StackVariable {
  SemanticStackVariable() { not this.isFromUninstantiatedTemplate(_) }
}
