/**
 * Provides `Callable` classes, which are things that can be called
 * such as methods and operators.
 */

import Member
import Stmt
import Type
import exprs.Call
private import commons.QualifiedName
private import commons.Collections
private import semmle.code.csharp.ExprOrStmtParent
private import semmle.code.csharp.metrics.Complexity
private import TypeRef

/**
 * An element that can be called.
 *
 * Either a method (`Method`), a constructor (`Constructor`), a destructor
 * (`Destructor`), an operator (`Operator`), an accessor (`Accessor`),
 * an anonymous function (`AnonymousFunctionExpr`), or a local function
 * (`LocalFunction`).
 */
class Callable extends Parameterizable, ExprOrStmtParent, @callable {
  /** Gets the return type of this callable. */
  Type getReturnType() { none() }

  /** Gets the annotated return type of this callable. */
  final AnnotatedType getAnnotatedReturnType() { result.appliesTo(this) }

  override Callable getUnboundDeclaration() {
    result = Parameterizable.super.getUnboundDeclaration()
  }

  /**
   * Gets the body of this callable, if any.
   *
   * The body is either a `BlockStmt` or an `Expr`.
   *
   * Normally, each callable will have at most one body, except in the case where
   * the same callable is compiled multiple times. For example, if we compile
   * both `A.cs`
   *
   * ```csharp
   * namespaces N {
   *   public class C {
   *     public int M() { return 0; }
   *   }
   * }
   * ```
   *
   * and later `B.cs`
   *
   * ```csharp
   * namespaces N {
   *   public class C {
   *     public int M() => 1;
   *   }
   * }
   * ```
   *
   * then both `{ return 0; }` and `1` are bodies of `N.C.M()`.
   */
  final ControlFlowElement getBody() {
    result = this.getStatementBody() or
    result = this.getExpressionBody()
  }

  /** Holds if this callable has a body or an implementation. */
  predicate hasBody() { exists(this.getBody()) }

  /**
   * Holds if this callable has a non-empty body. That is, either it has
   * an expression body, or it has a non-empty statement body.
   */
  predicate hasNonEmptyBody() {
    this.hasExpressionBody()
    or
    this.getStatementBody().stripSingletonBlocks() = any(Stmt s | not s.(BlockStmt).isEmpty())
  }

  /**
   * Gets the statement body of this callable, if any.
   *
   * Normally, each callable will have at most one statement body, except in the
   * case where the same callable is compiled multiple times. For example, if
   * we compile both `A.cs`
   *
   * ```csharp
   * namespaces N {
   *   public class C {
   *     public int M() { return 0; }
   *   }
   * }
   * ```
   *
   * and later `B.cs`
   *
   * ```csharp
   * namespaces N {
   *   public class C {
   *     public int M() { return 1; }
   *   }
   * }
   * ```
   *
   * then both `{ return 0; }` and `{ return 1; }` are statement bodies of
   * `N.C.M()`.
   */
  final BlockStmt getStatementBody() {
    result = getStatementBody(this) and
    not this.getFile().isStub()
  }

  /**
   * DEPRECATED: Use `getStatementBody` instead.
   */
  final BlockStmt getAStatementBody() { result = this.getStatementBody() }

  /** Holds if this callable has a statement body. */
  final predicate hasStatementBody() { exists(this.getStatementBody()) }

  /**
   * Gets the expression body of this callable (if any), specified by `=>`.
   *
   * Normally, each callable will have at most one expression body, except in the
   * case where the same callable is compiled multiple times. For example, if
   * we compile both `A.cs`
   *
   * ```csharp
   * namespaces N {
   *   public class C {
   *     public int M() => 0;
   *   }
   * }
   * ```
   *
   * and later `B.cs`
   *
   * ```csharp
   * namespaces N {
   *   public class C {
   *     public int M() => 1;
   *   }
   * }
   * ```
   *
   * then both `0` and `1` are expression bodies of `N.C.M()`.
   */
  final Expr getExpressionBody() {
    result = getExpressionBody(this) and
    not this.getFile().isStub()
  }

  /** Holds if this callable has an expression body. */
  final predicate hasExpressionBody() { exists(this.getExpressionBody()) }

  /** Gets the entry point in the control graph for this callable. */
  ControlFlow::Nodes::EntryNode getEntryPoint() { result.getCallable() = this }

  /** Gets the exit point in the control graph for this callable. */
  ControlFlow::Nodes::ExitNode getExitPoint() { result.getCallable() = this }

  /**
   * Gets the enclosing callable of this callable, if any.
   */
  Callable getEnclosingCallable() { none() }

  /**
   * Gets the number of branching statements (`if`, `while`, `do`, `for`, `foreach`
   * `switch`, `case`, `catch`) plus the number of branching
   * expressions (`?`, `&&`, `||`, `??`) plus one.
   * Callables with a high cyclomatic complexity (> 10) are
   * hard to test and maintain, given their large number of
   * possible execution paths. They should be refactored.
   */
  int getCyclomaticComplexity() { cyclomaticComplexity(this, result) }

  /** Gets the total number of lines in this callable. */
  int getNumberOfLines() { numlines(this, result, _, _) }

  /** Gets the number of lines containing code in this callable. */
  int getNumberOfLinesOfCode() { numlines(this, _, result, _) }

  /** Gets the number of lines containing comments in this callable. */
  int getNumberOfLinesOfComments() { numlines(this, _, _, result) }

  /**
   * Holds if `callee` is potentially called from this callable. That is,
   * `callee` is a potential run-time target of a call in the body of this
   * callable.
   */
  predicate calls(Callable callee) {
    exists(Call c |
      callee = c.getARuntimeTarget() and
      this = c.getEnclosingCallable() and
      c.isLive() // no need to consider unreachable calls
    )
  }

  /** Holds if this callable can return expression `e`. */
  predicate canReturn(Expr e) {
    exists(ReturnStmt ret | ret.getEnclosingCallable() = this | e = ret.getExpr())
    or
    e = this.getExpressionBody() and
    not this.getReturnType() instanceof VoidType and
    (
      not this.(Modifiable).isAsync() or
      this.getReturnType() instanceof Generic
    )
  }

  /** Holds if this callable can yield return the expression `e`. */
  predicate canYieldReturn(Expr e) {
    exists(YieldReturnStmt yield | yield.getEnclosingCallable() = this | e = yield.getExpr())
  }

  override string toStringWithTypes() {
    result = this.getName() + "(" + this.parameterTypesToString() + ")"
  }

  /** Gets a `Call` that has this callable as a target. */
  Call getACall() { this = result.getTarget() }
}

/**
 * A method, for example
 *
 * ```csharp
 * public override bool Equals(object other) {
 *   ...
 * }
 * ```
 */
class Method extends Callable, Virtualizable, Attributable, @method {
  /** Gets the name of this method. */
  override string getName() { methods(this, result, _, _, _) }

  override string getUndecoratedName() { methods(this, result, _, _, _) }

  override ValueOrRefType getDeclaringType() { methods(this, _, result, _, _) }

  override Type getReturnType() {
    methods(this, _, _, result, _)
    or
    not methods(this, _, _, any(Type t), _) and
    methods(this, _, _, getTypeRef(result), _)
  }

  override Method getUnboundDeclaration() { methods(this, _, _, _, result) }

  override Method getOverridee() { result = Virtualizable.super.getOverridee() }

  override Method getAnOverrider() { result = Virtualizable.super.getAnOverrider() }

  override Method getImplementee() { result = Virtualizable.super.getImplementee() }

  override Method getAnImplementor() { result = Virtualizable.super.getAnImplementor() }

  override Method getAnUltimateImplementee() {
    result = Virtualizable.super.getAnUltimateImplementee()
  }

  override Method getAnUltimateImplementor() {
    result = Virtualizable.super.getAnUltimateImplementor()
  }

  override Location getALocation() { method_location(this, result) }

  /** Holds if this method is an extension method. */
  predicate isExtensionMethod() { this.getParameter(0).hasExtensionMethodModifier() }

  /** Gets the type of the `params` parameter of this method, if any. */
  Type getParamsType() {
    exists(Parameter last | last = this.getParameter(this.getNumberOfParameters() - 1) |
      last.isParams() and
      result = last.getType().(ParamsCollectionType).getElementType()
    )
  }

  /** Holds if this method has a `params` parameter. */
  predicate hasParams() { exists(this.getParamsType()) }

  // Remove when `Callable.isOverridden()` is removed
  override predicate fromSource() {
    Callable.super.fromSource() and
    not this.isCompilerGenerated()
  }

  override string toString() { result = Callable.super.toString() }

  override Parameter getRawParameter(int i) {
    if this.isStatic() then result = this.getParameter(i) else result = this.getParameter(i - 1)
  }

  override string getAPrimaryQlClass() { result = "Method" }
}

/**
 * An extension method, for example
 *
 * ```csharp
 * static bool IsDefined(this Widget w) {
 *   ...
 * }
 * ```
 */
class ExtensionMethod extends Method {
  ExtensionMethod() { this.isExtensionMethod() }

  override predicate isStatic() { any() }

  /** Gets the type being extended by this method. */
  pragma[noinline]
  Type getExtendedType() { result = this.getParameter(0).getType() }

  override string getAPrimaryQlClass() { result = "ExtensionMethod" }
}

/**
 * A constructor, for example `public C() { }` on line 2 in
 *
 * ```csharp
 * class C {
 *   public C() { }
 * }
 * ```
 */
class Constructor extends Callable, Member, Attributable, @constructor {
  override string getName() { constructors(this, result, _, _) }

  override Type getReturnType() {
    exists(this) and // needed to avoid compiler warning
    result instanceof VoidType
  }

  /**
   * Gets the initializer of this constructor, if any. For example,
   * the initializer of the constructor on line 2 is `this(null)`
   * on line 3 in
   *
   * ```csharp
   * class C {
   *   public C()
   *     : this(null) { ... }
   *
   *   C(object o) { ... }
   * }
   * ```
   */
  ConstructorInitializer getInitializer() { result = this.getChildExpr(-1) }

  /** Holds if this constructor has an initializer. */
  predicate hasInitializer() { exists(this.getInitializer()) }

  override ValueOrRefType getDeclaringType() { constructors(this, _, result, _) }

  override Constructor getUnboundDeclaration() { constructors(this, _, _, result) }

  override Location getALocation() { constructor_location(this, result) }

  override predicate fromSource() { Member.super.fromSource() and not this.isCompilerGenerated() }

  override string toString() { result = Callable.super.toString() }

  override Parameter getRawParameter(int i) {
    if this.isStatic() then result = this.getParameter(i) else result = this.getParameter(i - 1)
  }

  /** Holds if this is a constructor without parameters. */
  predicate isParameterless() { this.getNumberOfParameters() = 0 }

  override string getUndecoratedName() { result = ".ctor" }
}

/**
 * A static constructor (as opposed to an instance constructor),
 * for example `static public C() { }` on line 2 in
 *
 * ```csharp
 * class C {
 *   static public C() { }
 * }
 * ```
 */
class StaticConstructor extends Constructor {
  StaticConstructor() { this.isStatic() }

  override string getUndecoratedName() { result = ".cctor" }

  override string getAPrimaryQlClass() { result = "StaticConstructor" }
}

/**
 * An instance constructor (as opposed to a static constructor),
 * for example `public C() { }` on line 2 in
 *
 * ```csharp
 * class C {
 *   public C() { }
 * }
 * ```
 */
class InstanceConstructor extends Constructor {
  InstanceConstructor() { not this.isStatic() }

  override string getAPrimaryQlClass() { result = "InstanceConstructor" }
}

/**
 * A primary constructor, for example `public class C(object o)` on line 1 in
 * ```csharp
 * public class C(object o) {
 *  ...
 * }
 * ```
 */
class PrimaryConstructor extends Constructor {
  PrimaryConstructor() {
    // In the extractor we use the constructor location as the location for the
    // synthesized empty body of the constructor.
    this.getLocation() = this.getBody().getLocation() and
    this.getDeclaringType().fromSource() and
    this.fromSource()
  }

  override string getAPrimaryQlClass() { result = "PrimaryConstructor" }
}

/**
 * A destructor, for example `~C() { }` on line 2 in
 *
 * ```csharp
 * class C {
 *   ~C() { }
 * }
 * ```
 */
class Destructor extends Callable, Member, Attributable, @destructor {
  override string getName() { destructors(this, result, _, _) }

  override Type getReturnType() {
    exists(this) and // needed to avoid compiler warning
    result instanceof VoidType
  }

  override string getUndecoratedName() { result = "Finalize" }

  override ValueOrRefType getDeclaringType() { destructors(this, _, result, _) }

  override Destructor getUnboundDeclaration() { destructors(this, _, _, result) }

  override Location getALocation() { destructor_location(this, result) }

  override string toString() { result = Callable.super.toString() }

  override string getAPrimaryQlClass() { result = "Destructor" }
}

/**
 * A user-defined operator.
 *
 * Either a unary operator (`UnaryOperator`), a binary operator
 * (`BinaryOperator`), or a conversion operator (`ConversionOperator`).
 */
class Operator extends Callable, Member, Attributable, Overridable, @operator {
  override string getName() { operators(this, _, result, _, _, _) }

  override string getUndecoratedName() { operators(this, _, result, _, _, _) }

  /**
   * Gets the metadata name of the operator, such as `op_implicit` or `op_RightShift`.
   */
  string getFunctionName() { operators(this, result, _, _, _, _) }

  override ValueOrRefType getDeclaringType() { operators(this, _, _, result, _, _) }

  override Type getReturnType() {
    operators(this, _, _, _, result, _)
    or
    not operators(this, _, _, _, any(Type t), _) and
    operators(this, _, _, _, getTypeRef(result), _)
  }

  override Operator getUnboundDeclaration() { operators(this, _, _, _, _, result) }

  override Location getALocation() { operator_location(this, result) }

  override string toString() { result = Callable.super.toString() }

  override Parameter getRawParameter(int i) { result = this.getParameter(i) }
}

pragma[nomagic]
private ValueOrRefType getARecordBaseType(ValueOrRefType t) {
  exists(Callable c |
    c.hasName("<Clone>$") and
    c.getNumberOfParameters() = 0 and
    t = c.getDeclaringType() and
    result = t
  )
  or
  result = getARecordBaseType(t).getABaseType()
}

/** A clone method on a record. */
class RecordCloneMethod extends Method {
  RecordCloneMethod() {
    this.hasName("<Clone>$") and
    this.getNumberOfParameters() = 0 and
    this.getReturnType() = getARecordBaseType(this.getDeclaringType()) and
    this.isPublic() and
    not this.isStatic()
  }

  /** Gets the constructor that this clone method calls. */
  Constructor getConstructor() {
    result.getDeclaringType() = this.getDeclaringType() and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() = this.getDeclaringType()
  }
}

/**
 * A user-defined unary operator - an operator taking one operand.
 *
 * Either a plus operator (`PlusOperator`), minus operator (`MinusOperator`),
 * checked minus operator (`CheckedMinusOperator`), not operator (`NotOperator`),
 * complement operator (`ComplementOperator`), true operator (`TrueOperator`),
 * false operator (`FalseOperator`), increment operator (`IncrementOperator`),
 * checked increment operator (`CheckedIncrementOperator`), decrement operator
 * (`DecrementOperator`) or checked decrement operator (`CheckedDecrementOperator`).
 */
class UnaryOperator extends Operator {
  UnaryOperator() {
    this.getNumberOfParameters() = 1 and
    not this instanceof ConversionOperator
  }
}

/**
 * A user-defined plus operator (`+`), for example
 *
 * ```csharp
 * public static Widget operator +(Widget w) {
 *   ...
 * }
 * ```
 */
class PlusOperator extends UnaryOperator {
  PlusOperator() { this.getName() = "+" }

  override string getAPrimaryQlClass() { result = "PlusOperator" }
}

/**
 * A user-defined minus operator (`-`), for example
 *
 * ```csharp
 * public static Widget operator -(Widget w) {
 *   ...
 * }
 * ```
 */
class MinusOperator extends UnaryOperator {
  MinusOperator() { this.getName() = "-" }

  override string getAPrimaryQlClass() { result = "MinusOperator" }
}

/**
 * A user-defined checked minus operator (`-`), for example
 *
 * ```csharp
 * public static Widget operator checked -(Widget w) {
 *   ...
 * }
 * ```
 */
class CheckedMinusOperator extends UnaryOperator {
  CheckedMinusOperator() { this.getName() = "checked -" }

  override string getAPrimaryQlClass() { result = "CheckedMinusOperator" }
}

/**
 * A user-defined not operator (`!`), for example
 *
 * ```csharp
 * public static bool operator !(Widget w) {
 *   ...
 * }
 * ```
 */
class NotOperator extends UnaryOperator {
  NotOperator() { this.getName() = "!" }

  override string getAPrimaryQlClass() { result = "NotOperator" }
}

/**
 * A user-defined complement operator (`~`), for example
 *
 * ```csharp
 * public static Widget operator ~(Widget w) {
 *   ...
 * }
 * ```
 */
class ComplementOperator extends UnaryOperator {
  ComplementOperator() { this.getName() = "~" }

  override string getAPrimaryQlClass() { result = "ComplementOperator" }
}

/**
 * A user-defined increment operator (`++`), for example
 *
 * ```csharp
 * public static Widget operator ++(Widget w) {
 *   ...
 * }
 * ```
 */
class IncrementOperator extends UnaryOperator {
  IncrementOperator() { this.getName() = "++" }

  override string getAPrimaryQlClass() { result = "IncrementOperator" }
}

/**
 * A user-defined checked increment operator (`++`), for example
 *
 * ```csharp
 * public static Widget operator checked ++(Widget w) {
 *   ...
 * }
 * ```
 */
class CheckedIncrementOperator extends UnaryOperator {
  CheckedIncrementOperator() { this.getName() = "checked ++" }

  override string getAPrimaryQlClass() { result = "CheckedIncrementOperator" }
}

/**
 * A user-defined decrement operator (`--`), for example
 *
 * ```csharp
 * public static Widget operator --(Widget w) {
 *   ...
 * }
 * ```
 */
class DecrementOperator extends UnaryOperator {
  DecrementOperator() { this.getName() = "--" }

  override string getAPrimaryQlClass() { result = "DecrementOperator" }
}

/**
 * A user-defined checked decrement operator (`--`), for example
 *
 * ```csharp
 * public static Widget operator checked --(Widget w) {
 *   ...
 * }
 * ```
 */
class CheckedDecrementOperator extends UnaryOperator {
  CheckedDecrementOperator() { this.getName() = "checked --" }

  override string getAPrimaryQlClass() { result = "CheckedDecrementOperator" }
}

/**
 * A user-defined false operator (`false`), for example
 *
 * ```csharp
 * public static bool operator false(Widget w) {
 *   ...
 * }
 * ```
 */
class FalseOperator extends UnaryOperator {
  FalseOperator() { this.getName() = "false" }

  override string getAPrimaryQlClass() { result = "FalseOperator" }
}

/**
 * A user-defined true operator (`true`), for example
 *
 * ```csharp
 * public static bool operator true(Widget w) {
 *   ...
 * }
 * ```
 */
class TrueOperator extends UnaryOperator {
  TrueOperator() { this.getName() = "true" }

  override string getAPrimaryQlClass() { result = "TrueOperator" }
}

/**
 * A user-defined binary operator.
 *
 * Either an addition operator (`AddOperator`), a checked addition operator
 * (`CheckedAddOperator`) a subtraction operator (`SubOperator`), a checked
 * substraction operator (`CheckedSubOperator`), a multiplication operator
 * (`MulOperator`), a checked multiplication operator (`CheckedMulOperator`),
 * a division operator (`DivOperator`), a checked division operator
 * (`CheckedDivOperator`), a remainder operator (`RemOperator`), an and
 * operator (`AndOperator`), an or operator (`OrOperator`), an xor
 * operator (`XorOperator`), a left shift operator (`LeftShiftOperator`),
 * a right shift operator (`RightShiftOperator`), an unsigned right shift
 * operator(`UnsignedRightShiftOperator`), an equals operator (`EQOperator`),
 * a not equals operator (`NEOperator`), a lesser than operator (`LTOperator`),
 * a greater than operator (`GTOperator`), a less than or equals operator
 * (`LEOperator`), or a greater than or equals operator (`GEOperator`).
 */
class BinaryOperator extends Operator {
  BinaryOperator() { this.getNumberOfParameters() = 2 }
}

/**
 * A user-defined addition operator (`+`), for example
 *
 * ```csharp
 * public static Widget operator +(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class AddOperator extends BinaryOperator {
  AddOperator() { this.getName() = "+" }

  override string getAPrimaryQlClass() { result = "AddOperator" }
}

/**
 * A user-defined checked addition operator (`+`), for example
 *
 * ```csharp
 * public static Widget operator checked +(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class CheckedAddOperator extends BinaryOperator {
  CheckedAddOperator() { this.getName() = "checked +" }

  override string getAPrimaryQlClass() { result = "CheckedAddOperator" }
}

/**
 * A user-defined subtraction operator (`-`), for example
 *
 * ```csharp
 * public static Widget operator -(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class SubOperator extends BinaryOperator {
  SubOperator() { this.getName() = "-" }

  override string getAPrimaryQlClass() { result = "SubOperator" }
}

/**
 * A user-defined checked subtraction operator (`-`), for example
 *
 * ```csharp
 * public static Widget operator checked -(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class CheckedSubOperator extends BinaryOperator {
  CheckedSubOperator() { this.getName() = "checked -" }

  override string getAPrimaryQlClass() { result = "CheckedSubOperator" }
}

/**
 * A user-defined multiplication operator (`*`), for example
 *
 * ```csharp
 * public static Widget operator *(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class MulOperator extends BinaryOperator {
  MulOperator() { this.getName() = "*" }

  override string getAPrimaryQlClass() { result = "MulOperator" }
}

/**
 * A user-defined checked multiplication operator (`*`), for example
 *
 * ```csharp
 * public static Widget operator checked *(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class CheckedMulOperator extends BinaryOperator {
  CheckedMulOperator() { this.getName() = "checked *" }

  override string getAPrimaryQlClass() { result = "CheckedMulOperator" }
}

/**
 * A user-defined division operator (`/`), for example
 *
 * ```csharp
 * public static Widget operator /(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class DivOperator extends BinaryOperator {
  DivOperator() { this.getName() = "/" }

  override string getAPrimaryQlClass() { result = "DivOperator" }
}

/**
 * A user-defined checked division operator (`/`), for example
 *
 * ```csharp
 * public static Widget operator checked /(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class CheckedDivOperator extends BinaryOperator {
  CheckedDivOperator() { this.getName() = "checked /" }

  override string getAPrimaryQlClass() { result = "CheckedDivOperator" }
}

/**
 * A user-defined remainder operator (`%`), for example
 *
 * ```csharp
 * public static Widget operator %(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class RemOperator extends BinaryOperator {
  RemOperator() { this.getName() = "%" }

  override string getAPrimaryQlClass() { result = "RemOperator" }
}

/**
 * A user-defined and operator (`&`), for example
 *
 * ```csharp
 * public static Widget operator &(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class AndOperator extends BinaryOperator {
  AndOperator() { this.getName() = "&" }

  override string getAPrimaryQlClass() { result = "AndOperator" }
}

/**
 * A user-defined or operator (`|`), for example
 *
 * ```csharp
 * public static Widget operator |(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class OrOperator extends BinaryOperator {
  OrOperator() { this.getName() = "|" }

  override string getAPrimaryQlClass() { result = "OrOperator" }
}

/**
 * A user-defined xor operator (`^`), for example
 *
 * ```csharp
 * public static Widget operator ^(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class XorOperator extends BinaryOperator {
  XorOperator() { this.getName() = "^" }

  override string getAPrimaryQlClass() { result = "XorOperator" }
}

/**
 * A user-defined left shift operator (`<<`), for example
 *
 * ```csharp
 * public static Widget operator <<(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class LeftShiftOperator extends BinaryOperator {
  LeftShiftOperator() { this.getName() = "<<" }

  override string getAPrimaryQlClass() { result = "LeftShiftOperator" }
}

/**
 * A user-defined right shift operator (`>>`), for example
 *
 * ```csharp
 * public static Widget operator >>(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class RightShiftOperator extends BinaryOperator {
  RightShiftOperator() { this.getName() = ">>" }

  override string getAPrimaryQlClass() { result = "RightShiftOperator" }
}

/**
 * A user-defined unsigned right shift operator (`>>>`), for example
 *
 * ```csharp
 * public static Widget operator >>>(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class UnsignedRightShiftOperator extends BinaryOperator {
  UnsignedRightShiftOperator() { this.getName() = ">>>" }

  override string getAPrimaryQlClass() { result = "UnsignedRightShiftOperator" }
}

/**
 * A user-defined equals operator (`==`), for example
 *
 * ```csharp
 * public static bool operator ==(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class EQOperator extends BinaryOperator {
  EQOperator() { this.getName() = "==" }

  override string getAPrimaryQlClass() { result = "EQOperator" }
}

/**
 * A user-defined not equals operator (`!=`), for example
 *
 * ```csharp
 * public static bool operator !=(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class NEOperator extends BinaryOperator {
  NEOperator() { this.getName() = "!=" }

  override string getAPrimaryQlClass() { result = "NEOperator" }
}

/**
 * A user-defined lesser than operator (`<`), for example
 *
 * ```csharp
 * public static bool operator <(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class LTOperator extends BinaryOperator {
  LTOperator() { this.getName() = "<" }

  override string getAPrimaryQlClass() { result = "LTOperator" }
}

/**
 * A user-defined greater than operator (`>`), for example
 *
 * ```csharp
 * public static bool operator >(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class GTOperator extends BinaryOperator {
  GTOperator() { this.getName() = ">" }

  override string getAPrimaryQlClass() { result = "GTOperator" }
}

/**
 * A user-defined less than or equals operator (`<=`), for example
 *
 * ```csharp
 * public static bool operator <=(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class LEOperator extends BinaryOperator {
  LEOperator() { this.getName() = "<=" }

  override string getAPrimaryQlClass() { result = "LEOperator" }
}

/**
 * A user-defined greater than or equals operator (`>=`), for example
 *
 * ```csharp
 * public static bool operator >=(Widget lhs, Widget rhs) {
 *   ...
 * }
 * ```
 */
class GEOperator extends BinaryOperator {
  GEOperator() { this.getName() = ">=" }

  override string getAPrimaryQlClass() { result = "GEOperator" }
}

/**
 * A user-defined conversion operator, for example
 *
 * ```csharp
 * public static implicit operator int(BigInteger i) {
 *   ...
 * }
 * ```
 */
class ConversionOperator extends Operator {
  ConversionOperator() {
    this.getName() = "implicit conversion" or
    this.getName() = "explicit conversion" or
    this.getName() = "checked explicit conversion"
  }

  /** Gets the source type of the conversion. */
  Type getSourceType() { result = this.getParameter(0).getType() }

  /** Gets the target type of the conversion. */
  Type getTargetType() { result = this.getReturnType() }
}

/**
 * A user-defined implicit conversion operator, for example
 *
 * ```csharp
 * public static implicit operator int(BigInteger i) {
 *   ...
 * }
 * ```
 */
class ImplicitConversionOperator extends ConversionOperator {
  ImplicitConversionOperator() { this.getName() = "implicit conversion" }

  override string getAPrimaryQlClass() { result = "ImplicitConversionOperator" }
}

/**
 * A user-defined explicit conversion operator, for example
 *
 * ```csharp
 * public static explicit operator int(BigInteger i) {
 *   ...
 * }
 * ```
 */
class ExplicitConversionOperator extends ConversionOperator {
  ExplicitConversionOperator() { this.getName() = "explicit conversion" }

  override string getAPrimaryQlClass() { result = "ExplicitConversionOperator" }
}

/**
 * A user-defined checked explicit conversion operator, for example
 *
 * ```csharp
 * public static explicit operator checked int(BigInteger i) {
 *   ...
 * }
 * ```
 */
class CheckedExplicitConversionOperator extends ConversionOperator {
  CheckedExplicitConversionOperator() { this.getName() = "checked explicit conversion" }

  override string getAPrimaryQlClass() { result = "CheckedExplicitConversionOperator" }
}

/**
 * A local function, defined within the scope of another callable.
 * For example, `Fac` on lines 2--4 in
 *
 * ```csharp
 * int Choose(int n, int m) {
 *   int Fac(int x) {
 *     return x > 1 ? x * Fac(x - 1) : 1;
 *   }
 *
 *   return Fac(n) / (Fac(m) * Fac(n - m));
 * }
 * ```
 */
class LocalFunction extends Callable, Modifiable, Attributable, @local_function {
  override string getName() { local_functions(this, result, _, _) }

  override string getUndecoratedName() { local_functions(this, result, _, _) }

  override LocalFunction getUnboundDeclaration() { local_functions(this, _, _, result) }

  override Type getReturnType() { local_functions(this, _, result, _) }

  override Element getParent() { result = this.getStatement().getParent() }

  /** Gets the local function statement defining this function. */
  LocalFunctionStmt getStatement() { result.getLocalFunction() = this.getUnboundDeclaration() }

  override Callable getEnclosingCallable() { result = this.getStatement().getEnclosingCallable() }

  override Location getALocation() { result = this.getStatement().getALocation() }

  override Parameter getRawParameter(int i) { result = this.getParameter(i) }

  override string getAPrimaryQlClass() { result = "LocalFunction" }

  override string toString() { result = Callable.super.toString() }
}
