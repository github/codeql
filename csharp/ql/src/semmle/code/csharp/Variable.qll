/**
 * Provides classes for variables, such as fields, parameters, local variables, and
 * constants.
 */

import Assignable
import Callable
import Element
import Type
private import dotnet
private import semmle.code.csharp.ExprOrStmtParent
private import TypeRef

/**
 * A variable. Either a variable with local scope (`LocalScopeVariable`) or a field (`Field`).
 */
class Variable extends Assignable, DotNet::Variable, @variable {
  override Variable getSourceDeclaration() { result = this }

  override VariableAccess getAnAccess() { result.getTarget() = this }

  override Type getType() { none() }

  /** Gets the expression used to initialise this variable, if any. */
  Expr getInitializer() { none() }
}

/**
 * A locally scoped variable. Either a local variable (`LocalVariable`)
 * or a parameter (`Parameter`).
 */
class LocalScopeVariable extends Variable, @local_scope_variable {
  /** Gets the callable in which this variable is defined. */
  Callable getCallable() { none() }

  /**
   * Holds if this variable is captured by a nested callable. For example,
   * `v` is captured by the nested lambda expression in
   *
   * ```csharp
   * void M() {
   *   var v = "captured";
   *   Action a = () => {
   *     System.Console.WriteLine(v);
   *   }
   * }
   * ```
   */
  predicate isCaptured() { exists(this.getACapturingCallable()) }

  /**
   * Gets a callable that captures this variable, if any. For example,
   * `v` is captured by the nested lambda expression in
   *
   * ```csharp
   * void M() {
   *   var v = "captured";
   *   Action a = () => {
   *     System.Console.WriteLine(v);
   *   }
   * }
   * ```
   */
  Callable getACapturingCallable() {
    result = this.getAnAccess().getEnclosingCallable() and
    result != this.getCallable()
  }

  /**
   * Holds if this local variable or parameter is a `ref`.
   */
  predicate isRef() { none() }

  override predicate hasQualifiedName(string qualifier, string name) { none() }
}

/**
 * A parameter of a parameterizable declaration (callable, delegate, or indexer).
 * For example, `p` in
 *
 * ```csharp
 * void M(int p) {
 *   ...
 * }
 * ```
 */
class Parameter extends DotNet::Parameter, LocalScopeVariable, Attributable, TopLevelExprParent,
  @parameter {
  /**
   * Gets the position of this parameter. For example, the position of `x` is
   * 0 and the position of `y` is 1 in
   *
   * ```csharp
   * void M(int x, int y) {
   *   ...
   * }
   * ```
   */
  override int getPosition() { params(this, _, _, result, _, _, _) }

  override int getIndex() { result = this.getPosition() }

  /**
   * Holds if this parameter is a normal value parameter. For example, `p`
   * is a value parameter in
   *
   * ```csharp
   * void M(int p) {
   *   ...
   * }
   * ```
   */
  predicate isValue() { params(this, _, _, _, 0, _, _) }

  /**
   * Holds if this parameter is a reference parameter. For example, `p`
   * is a reference parameter in
   *
   * ```csharp
   * void M(ref int p) {
   *   ...
   * }
   * ```
   */
  override predicate isRef() { params(this, _, _, _, 1, _, _) }

  /**
   * Holds if this parameter is an output parameter. For example, `p`
   * is an output parameter in
   *
   * ```csharp
   * void M(out int p) {
   *   ...
   * }
   * ```
   */
  override predicate isOut() { params(this, _, _, _, 2, _, _) }

  /**
   * Holds if this parameter is a value type that is passed in by reference.
   * For example, `p` is an input parameter in
   *
   * ```csharp
   * void M(in int p) {
   *   ...
   * }
   * ```
   */
  predicate isIn() { params(this, _, _, _, 5, _, _) }

  /** Holds if this parameter is an output or reference parameter. */
  predicate isOutOrRef() { isOut() or isRef() }

  /**
   * Holds if this parameter is a parameter array. For example, `args`
   * is a parameter array in
   *
   * ```csharp
   * void M(params string[] args) {
   *   ...
   * }
   * ```
   */
  predicate isParams() { params(this, _, _, _, 3, _, _) }

  /**
   * Holds this parameter is the first parameter of an extension method.
   * For example, `list` is the first parameter of the extension method
   * `Count` in
   *
   * ```csharp
   * static int Count(this IEnumerable list) {
   *   ...
   * }
   * ```
   */
  predicate hasExtensionMethodModifier() { params(this, _, _, _, 4, _, _) }

  /** Gets the declaring element of this parameter. */
  Parameterizable getDeclaringElement() { params(this, _, _, _, _, result, _) }

  override Parameter getSourceDeclaration() { params(this, _, _, _, _, _, result) }

  override ValueOrRefType getDeclaringType() {
    exists(Parameterizable p | p = this.getDeclaringElement() |
      if p instanceof DelegateType then result = p else result = p.getDeclaringType()
    )
  }

  override string getName() { params(this, result, _, _, _, _, _) }

  override Type getType() { params(this, _, getTypeRef(result), _, _, _, _) }

  override Location getALocation() { param_location(this, result) }

  override string toString() { result = this.getName() }

  override string getAPrimaryQlClass() { result = "Parameter" }

  /**
   * Gets the default value of this parameter, if any. For example, the
   * default value of `numberOfTries` is `3` in
   *
   * ```csharp
   * void Connect(int numberOfTries = 3) {
   *   ...
   * }
   * ```
   */
  Expr getDefaultValue() { result = this.getSourceDeclaration().getChildExpr(0) }

  /** Holds if this parameter has a default value. */
  predicate hasDefaultValue() { exists(getDefaultValue()) }

  /** Gets the callable to which this parameter belongs, if any. */
  override Callable getCallable() { result.getAParameter() = this }

  /**
   * Gets an argument which is assigned to this parameter in a call to the
   * enclosing callable.
   *
   * This takes into account both positional and named arguments.
   *
   * Example:
   *
   * ```csharp
   * class C {
   *   void M(int x, int y = 2, int z = 3) { }
   *
   *   void CallM() {
   *     M(4, 5, 6);
   *     M(1, z: 3);
   *   }
   * }
   * ```
   *
   * The assigned arguments to `x` are `1` and `4`, the assigned argument to
   * `y` is `5`, and the assigned arguments to `z` are `3` and `6`, respectively.
   */
  Expr getAnAssignedArgument() { result = getCallable().getACall().getArgumentForParameter(this) }

  /** Holds if this parameter is potentially overwritten in the body of its callable. */
  predicate isOverwritten() {
    not this.isOut() and
    // At least one other definition than the implicit entry definition
    strictcount(AssignableDefinition def | def.getTarget() = this) > 1
  }
}

/**
 * An implicit accessor or event accessor parameter corresponding to the
 * special `value` parameter. For example, the `value` parameter of
 * `set_ReadOnly` in
 *
 * ```csharp
 * public bool ReadOnly {
 *   get {
 *     return flags.HasValue(Attribute.ReadOnly);
 *   }
 *
 *   set {
 *     flags = value ? flags|Attribute.ReadOnly : flags&~Attribute.ReadOnly;
 *   }
 * }
 * ```
 */
class ImplicitAccessorParameter extends Parameter {
  ImplicitAccessorParameter() {
    this.getDeclaringElement() instanceof Accessor and
    this.hasName("value")
  }
}

/**
 * A local variable, declared within the scope of a callable. For example,
 * the variables `total` and `s` in
 *
 * ```csharp
 * void M(string[] ss) {
 *   int total = 0;
 *   ...
 *   foreach (var s in ss)
 *     ...
 * }
 * ```
 */
class LocalVariable extends LocalScopeVariable, @local_variable {
  /** Gets the declaration of this local variable. */
  LocalVariableDeclExpr getVariableDeclExpr() { result.getVariable() = this }

  /**
   * Gets the initializer expression of this local variable, if any.
   * For example, the initializer of `total` is `0`, and `s` has no
   * initializer, in
   *
   * ```csharp
   * void M(string[] ss) {
   *   int total = 0;
   *   ...
   *   foreach (var s in ss)
   *     ...
   * }
   * ```
   */
  override Expr getInitializer() { result = this.getVariableDeclExpr().getInitializer() }

  /**
   * Holds if this variable is implicitly typed. For example, the variable
   * `s` is implicitly type, and the variable `total` is not, in
   *
   * ```csharp
   * void M(string[] ss) {
   *   int total = 0;
   *   ...
   *   foreach (var s in ss)
   *     ...
   * }
   * ```
   */
  predicate isImplicitlyTyped() { localvars(this, _, _, 1, _, _) }

  /** Gets the enclosing callable of this local variable. */
  Callable getEnclosingCallable() { result = this.getVariableDeclExpr().getEnclosingCallable() }

  override Callable getCallable() { result = getEnclosingCallable() }

  override predicate isRef() { localvars(this, 3, _, _, _, _) }

  override ValueOrRefType getDeclaringType() {
    result = this.getVariableDeclExpr().getEnclosingCallable().getDeclaringType()
  }

  override string getName() { localvars(this, _, result, _, _, _) }

  override Type getType() { localvars(this, _, _, _, getTypeRef(result), _) }

  override Location getALocation() { localvar_location(this, result) }
}

/**
 * A local constant, modeled as a special kind of local variable. For example,
 * the local constant `maxTries` in
 *
 * ```csharp
 * void M() {
 *   const int maxTries = 10;
 *   ...
 * }
 * ```
 */
class LocalConstant extends LocalVariable, @local_constant {
  /** Gets the declaration of this local constant. */
  override LocalConstantDeclExpr getVariableDeclExpr() { result.getVariable() = this }

  /** Gets the computed value of this local constant. */
  string getValue() { constant_value(this, result) }
}

/**
 * A field. For example, the fields `x` and `y` in
 *
 * ```csharp
 * struct Coord {
 *   public int x, y;
 * }
 * ```
 */
class Field extends Variable, AssignableMember, Attributable, TopLevelExprParent, DotNet::Field,
  @field {
  /**
   * Gets the initial value of this field, if any. For example, the initial
   * value of `F` on line 2 is `20` in
   *
   * ```csharp
   * class C {
   *   public int F = 20;
   * }
   * ```
   */
  override Expr getInitializer() { result = this.getChildExpr(0).getChildExpr(0) }

  /**
   * Holds if this field has an initial value. For example, the initial
   * value of `F` on line 2 is `20` in
   *
   * ```csharp
   * class C {
   *   public int F = 20;
   * }
   * ```
   */
  predicate hasInitializer() { exists(this.getInitializer()) }

  /** Holds if this field is `volatile`. */
  predicate isVolatile() { this.hasModifier("volatile") }

  /** Holds if this field is `readonly`. */
  predicate isReadOnly() { this.hasModifier("readonly") }

  override Field getSourceDeclaration() { fields(this, _, _, _, _, result) }

  override FieldAccess getAnAccess() { result = Variable.super.getAnAccess() }

  override ValueOrRefType getDeclaringType() { fields(this, _, _, result, _, _) }

  override string getName() { fields(this, _, result, _, _, _) }

  override Type getType() { fields(this, _, _, _, getTypeRef(result), _) }

  override Location getALocation() { field_location(this, result) }

  override string toString() { result = Variable.super.toString() }

  override string getAPrimaryQlClass() { result = "Field" }
}

/**
 * A member constant, modeled a special kind of field. For example,
 * the constant `Separator` in
 *
 * ```csharp
 * class Path {
 *   const char Separator = `\\`;
 *   ...
 * }
 * ```
 */
class MemberConstant extends Field, @constant {
  /** Gets the computed value of this constant. */
  string getValue() { constant_value(this, result) }
}

/**
 * An `enum` member constant. For example, `ReadOnly` and `Shared` in
 *
 * ```csharp
 * enum Attribute {
 *   ReadOnly = 1,
 *   Shared = 2
 * }
 * ```
 */
class EnumConstant extends MemberConstant {
  EnumConstant() { this.getDeclaringType() instanceof Enum }

  /** Gets the `enum` that declares this constant. */
  Enum getDeclaringEnum() { result = this.getDeclaringType() }

  /**
   * Gets the underlying integral type of this `enum` constant. For example,
   * the underlying type of `Attribute` is `byte` in
   *
   * ```csharp
   * enum Attribute : byte {
   *   ReadOnly = 1,
   *   Shared = 2
   * }
   * ```
   */
  IntegralType getUnderlyingType() { result = this.getDeclaringEnum().getUnderlyingType() }

  /**
   * Holds if this `enum` constant has an explicit value. If not,
   * its value is automatically determined by the compiler.
   * In this example, `ReadOnly` has an explicit value but
   * `Shared` does not have an explicit value.
   *
   * ```csharp
   * enum Attribute {
   *   ReadOnly = 1,
   *   Shared
   * }
   * ```
   */
  predicate hasExplicitValue() { exists(this.getInitializer()) }

  override Expr getInitializer() { result = this.getChildExpr(0) }
}
