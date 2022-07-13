/**
 * Provides `Callable` classes, which are things that can be called
 * such as methods and operators.
 */

import Member
import Stmt
import Type
import exprs.Call
private import dotnet
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
class Callable extends DotNet::Callable, Parameterizable, ExprOrStmtParent, @callable {
  override Type getReturnType() { none() }

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

  override predicate hasBody() { exists(this.getBody()) }

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
  final BlockStmt getStatementBody() { result = this.getAChildStmt() }

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
    result = this.getAChildExpr() and
    not result = this.(Constructor).getInitializer()
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

  override predicate canReturn(DotNet::Expr e) {
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

  override Parameter getParameter(int n) { result = Parameterizable.super.getParameter(n) }

  override Parameter getAParameter() { result = Parameterizable.super.getAParameter() }

  override int getNumberOfParameters() { result = Parameterizable.super.getNumberOfParameters() }
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

  override Type getReturnType() { methods(this, _, _, getTypeRef(result), _) }

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
      result = last.getType().(ArrayType).getElementType()
    )
  }

  /** Holds if this method has a `params` parameter. */
  predicate hasParams() { exists(this.getParamsType()) }

  // Remove when `Callable.isOverridden()` is removed
  override predicate isOverridden() { Virtualizable.super.isOverridden() }

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
class Constructor extends DotNet::Constructor, Callable, Member, Attributable, @constructor {
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
 * A destructor, for example `~C() { }` on line 2 in
 *
 * ```csharp
 * class C {
 *   ~C() { }
 * }
 * ```
 */
class Destructor extends DotNet::Destructor, Callable, Member, Attributable, @destructor {
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
class Operator extends Callable, Member, Attributable, @operator {
  /** Gets the assembly name of this operator. */
  string getAssemblyName() { operators(this, result, _, _, _, _) }

  override string getName() { operators(this, _, result, _, _, _) }

  override string getUndecoratedName() { operators(this, _, result, _, _, _) }

  /**
   * Gets the metadata name of the operator, such as `op_implicit` or `op_RightShift`.
   */
  string getFunctionName() { none() }

  override ValueOrRefType getDeclaringType() { operators(this, _, _, result, _, _) }

  override Type getReturnType() { operators(this, _, _, _, getTypeRef(result), _) }

  override Operator getUnboundDeclaration() { operators(this, _, _, _, _, result) }

  override Location getALocation() { operator_location(this, result) }

  override string toString() { result = Callable.super.toString() }

  override Parameter getRawParameter(int i) { result = this.getParameter(i) }

  override predicate hasQualifiedName(string qualifier, string name) {
    super.hasQualifiedName(qualifier, _) and
    name = this.getFunctionName()
  }
}

/** A clone method on a record. */
class RecordCloneMethod extends Method, DotNet::RecordCloneCallable {
  override Constructor getConstructor() {
    result = DotNet::RecordCloneCallable.super.getConstructor()
  }

  override string toString() { result = Method.super.toString() }
}

/**
 * A user-defined unary operator - an operator taking one operand.
 *
 * Either a plus operator (`PlusOperator`), minus operator (`MinusOperator`),
 * not operator (`NotOperator`), complement operator (`ComplementOperator`),
 * true operator (`TrueOperator`), false operator (`FalseOperator`),
 * increment operator (`IncrementOperator`), or decrement operator
 * (`DecrementOperator`).
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

  override string getFunctionName() { result = "op_UnaryPlus" }

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

  override string getFunctionName() { result = "op_UnaryNegation" }

  override string getAPrimaryQlClass() { result = "MinusOperator" }
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

  override string getFunctionName() { result = "op_LogicalNot" }

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

  override string getFunctionName() { result = "op_OnesComplement" }

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

  override string getFunctionName() { result = "op_Increment" }

  override string getAPrimaryQlClass() { result = "IncrementOperator" }
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

  override string getFunctionName() { result = "op_Decrement" }

  override string getAPrimaryQlClass() { result = "DecrementOperator" }
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

  override string getFunctionName() { result = "op_False" }

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

  override string getFunctionName() { result = "op_True" }

  override string getAPrimaryQlClass() { result = "TrueOperator" }
}

/**
 * A user-defined binary operator.
 *
 * Either an addition operator (`AddOperator`), a subtraction operator
 * (`SubOperator`), a multiplication operator (`MulOperator`), a division
 * operator (`DivOperator`), a remainder operator (`RemOperator`), an and
 * operator (`AndOperator`), an or operator (`OrOperator`), an xor
 * operator (`XorOperator`), a left shift operator (`LShiftOperator`),
 * a right shift operator (`RShiftOperator`), an equals operator (`EQOperator`),
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

  override string getFunctionName() { result = "op_Addition" }

  override string getAPrimaryQlClass() { result = "AddOperator" }
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

  override string getFunctionName() { result = "op_Subtraction" }

  override string getAPrimaryQlClass() { result = "SubOperator" }
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

  override string getFunctionName() { result = "op_Multiply" }

  override string getAPrimaryQlClass() { result = "MulOperator" }
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

  override string getFunctionName() { result = "op_Division" }

  override string getAPrimaryQlClass() { result = "DivOperator" }
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

  override string getFunctionName() { result = "op_Modulus" }

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

  override string getFunctionName() { result = "op_BitwiseAnd" }

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

  override string getFunctionName() { result = "op_BitwiseOr" }

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

  override string getFunctionName() { result = "op_ExclusiveOr" }

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
class LShiftOperator extends BinaryOperator {
  LShiftOperator() { this.getName() = "<<" }

  override string getFunctionName() { result = "op_LeftShift" }

  override string getAPrimaryQlClass() { result = "LShiftOperator" }
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
class RShiftOperator extends BinaryOperator {
  RShiftOperator() { this.getName() = ">>" }

  override string getFunctionName() { result = "op_RightShift" }

  override string getAPrimaryQlClass() { result = "RShiftOperator" }
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

  override string getFunctionName() { result = "op_Equality" }

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

  override string getFunctionName() { result = "op_Inequality" }

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

  override string getFunctionName() { result = "op_LessThan" }

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

  override string getFunctionName() { result = "op_GreaterThan" }

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

  override string getFunctionName() { result = "op_LessThanOrEqual" }

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

  override string getFunctionName() { result = "op_GreaterThanOrEqual" }

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
    this.getName() = "explicit conversion"
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

  override string getFunctionName() { result = "op_Implicit" }

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

  override string getFunctionName() { result = "op_Explicit" }

  override string getAPrimaryQlClass() { result = "ExplicitConversionOperator" }
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

  override predicate hasQualifiedName(string qualifier, string name) {
    qualifier = this.getEnclosingCallable().getQualifiedName() and
    name = this.getName()
  }

  override Location getALocation() { result = this.getStatement().getALocation() }

  override Parameter getRawParameter(int i) { result = this.getParameter(i) }

  override string getAPrimaryQlClass() { result = "LocalFunction" }

  override string toString() { result = Callable.super.toString() }
}
