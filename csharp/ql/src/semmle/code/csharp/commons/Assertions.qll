/** Provides classes for assertions. */

private import semmle.code.csharp.frameworks.system.Diagnostics
private import semmle.code.csharp.frameworks.system.diagnostics.Contracts
private import semmle.code.csharp.frameworks.test.VisualStudio
private import semmle.code.csharp.frameworks.System
private import ControlFlow
private import ControlFlow::BasicBlocks

/** An assertion method. */
abstract class AssertMethod extends Method {
  /** Gets the index of the parameter being asserted. */
  abstract int getAssertionIndex();

  /** Gets the parameter being asserted. */
  final Parameter getAssertedParameter() { result = this.getParameter(this.getAssertionIndex()) }

  /** Gets the exception being thrown if the assertion fails, if any. */
  abstract Class getExceptionClass();
}

/** A positive assertion method. */
abstract class AssertTrueMethod extends AssertMethod { }

/** A negated assertion method. */
abstract class AssertFalseMethod extends AssertMethod { }

/** A `null` assertion method. */
abstract class AssertNullMethod extends AssertMethod { }

/** A non-`null` assertion method. */
abstract class AssertNonNullMethod extends AssertMethod { }

/** An assertion, that is, a call to an assertion method. */
class Assertion extends MethodCall {
  private AssertMethod target;

  Assertion() { this.getTarget() = target }

  /** Gets the assertion method targeted by this assertion. */
  AssertMethod getAssertMethod() { result = target }

  /** Gets the expression that this assertion pertains to. */
  Expr getExpr() { result = this.getArgumentForParameter(target.getAssertedParameter()) }

  /**
   * Holds if basic block `succ` is immediately dominated by this assertion.
   * That is, `succ` can only be reached from the callable entry point by
   * going via *some* basic block `pred` containing this assertion, and `pred`
   * is an immediate predecessor of `succ`.
   *
   * Moreover, this assertion corresponds to multiple control flow nodes,
   * which is why
   *
   * ```ql
   * exists(BasicBlock bb |
   *   bb.getANode() = this.getAControlFlowNode() |
   *   bb.immediatelyDominates(succ)
   * )
   * ```
   *
   * does not work.
   */
  pragma[nomagic]
  deprecated private predicate immediatelyDominatesBlockSplit(BasicBlock succ) {
    // Only calculate dominance by explicit recursion for split nodes;
    // all other nodes can use regular CFG dominance
    this instanceof ControlFlow::Internal::SplitControlFlowElement and
    exists(BasicBlock bb | bb.getANode() = this.getAControlFlowNode() |
      succ = bb.getASuccessor() and
      forall(BasicBlock pred | pred = succ.getAPredecessor() and pred != bb |
        succ.dominates(pred)
        or
        // `pred` might be another split of this element
        pred.getANode().getElement() = this
      )
    )
  }

  pragma[noinline]
  deprecated private predicate strictlyDominatesJoinBlockPredecessor(JoinBlock jb, int i) {
    this.strictlyDominatesSplit(jb.getJoinBlockPredecessor(i))
  }

  deprecated private predicate strictlyDominatesJoinBlockSplit(JoinBlock jb, int i) {
    i = -1 and
    this.strictlyDominatesJoinBlockPredecessor(jb, _)
    or
    this.strictlyDominatesJoinBlockSplit(jb, i - 1) and
    (
      this.strictlyDominatesJoinBlockPredecessor(jb, i)
      or
      this.getAControlFlowNode().getBasicBlock() = jb.getJoinBlockPredecessor(i)
    )
  }

  pragma[nomagic]
  deprecated private predicate strictlyDominatesSplit(BasicBlock bb) {
    this.immediatelyDominatesBlockSplit(bb)
    or
    // Equivalent with
    //
    // ```ql
    // exists(JoinBlockPredecessor pred | pred = bb.getAPredecessor() |
    //   this.strictlyDominatesSplit(pred)
    // ) and
    // forall(JoinBlockPredecessor pred | pred = bb.getAPredecessor() |
    //   this.strictlyDominatesSplit(pred)
    //   or
    //   this.getAControlFlowNode().getBasicBlock() = pred
    // )
    // ```
    //
    // but uses no universal recursion for better performance.
    exists(int last | last = max(int i | exists(bb.(JoinBlock).getJoinBlockPredecessor(i))) |
      this.strictlyDominatesJoinBlockSplit(bb, last)
    )
    or
    not bb instanceof JoinBlock and
    this.strictlyDominatesSplit(bb.getAPredecessor())
  }

  /**
   * DEPRECATED: Use `getExpr().controlsBlock()` instead.
   *
   * Holds if this assertion strictly dominates basic block `bb`. That is, `bb`
   * can only be reached from the callable entry point by going via *some* basic
   * block containing this element.
   *
   * This predicate is different from
   * `this.getAControlFlowNode().getBasicBlock().strictlyDominates(bb)`
   * in that it takes control flow splitting into account.
   */
  pragma[nomagic]
  deprecated predicate strictlyDominates(BasicBlock bb) {
    this.strictlyDominatesSplit(bb)
    or
    this.getAControlFlowNode().getBasicBlock().strictlyDominates(bb)
  }
}

/** A trivially failing assertion, for example `Debug.Assert(false)`. */
class FailingAssertion extends Assertion {
  FailingAssertion() {
    exists(AssertMethod am, Expr e |
      am = this.getAssertMethod() and
      e = this.getExpr()
    |
      am instanceof AssertTrueMethod and
      e.getValue() = "false"
      or
      am instanceof AssertFalseMethod and
      e.getValue() = "true"
    )
  }
}

/**
 * A `System.Diagnostics.Debug` assertion method.
 */
class SystemDiagnosticsDebugAssertTrueMethod extends AssertTrueMethod {
  SystemDiagnosticsDebugAssertTrueMethod() {
    this = any(SystemDiagnosticsDebugClass c).getAssertMethod()
  }

  override int getAssertionIndex() { result = 0 }

  override Class getExceptionClass() {
    // A failing assertion generates a message box, see
    // https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.debug.assert
    none()
  }
}

/**
 * A `System.Diagnostics.Contracts.Contract` assertion method.
 */
class SystemDiagnosticsContractAssertTrueMethod extends AssertTrueMethod {
  SystemDiagnosticsContractAssertTrueMethod() {
    exists(SystemDiagnosticsContractsContractClass c |
      this = c.getAnAssertMethod()
      or
      this = c.getAnAssumeMethod()
      or
      this = c.getARequiresMethod()
    )
  }

  override int getAssertionIndex() { result = 0 }

  override Class getExceptionClass() {
    // A failing assertion generates a message box, see
    // https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.contracts.contract.assert
    none()
  }
}

/** A Visual Studio assertion method. */
class VSTestAssertTrueMethod extends AssertTrueMethod {
  VSTestAssertTrueMethod() { this = any(VSTestAssertClass c).getIsTrueMethod() }

  override int getAssertionIndex() { result = 0 }

  override AssertFailedExceptionClass getExceptionClass() { any() }
}

/** A Visual Studio negated assertion method. */
class VSTestAssertFalseMethod extends AssertFalseMethod {
  VSTestAssertFalseMethod() { this = any(VSTestAssertClass c).getIsFalseMethod() }

  override int getAssertionIndex() { result = 0 }

  override AssertFailedExceptionClass getExceptionClass() { any() }
}

/** A Visual Studio `null` assertion method. */
class VSTestAssertNullMethod extends AssertNullMethod {
  VSTestAssertNullMethod() { this = any(VSTestAssertClass c).getIsNullMethod() }

  override int getAssertionIndex() { result = 0 }

  override AssertFailedExceptionClass getExceptionClass() { any() }
}

/** A Visual Studio non-`null` assertion method. */
class VSTestAssertNonNullMethod extends AssertNonNullMethod {
  VSTestAssertNonNullMethod() { this = any(VSTestAssertClass c).getIsNotNullMethod() }

  override int getAssertionIndex() { result = 0 }

  override AssertFailedExceptionClass getExceptionClass() { any() }
}

/** An NUnit assertion method. */
abstract class NUnitAssertMethod extends AssertMethod {
  override int getAssertionIndex() { result = 0 }

  override AssertionExceptionClass getExceptionClass() { any() }
}

/** An NUnit assertion method. */
class NUnitAssertTrueMethod extends AssertTrueMethod, NUnitAssertMethod {
  NUnitAssertTrueMethod() {
    exists(NUnitAssertClass c |
      this = c.getATrueMethod()
      or
      this = c.getAnIsTrueMethod()
      or
      this = c.getAThatMethod() and
      this.getParameter(0).getType() instanceof BoolType
    )
  }
}

/** An NUnit negated assertion method. */
class NUnitAssertFalseMethod extends AssertFalseMethod, NUnitAssertMethod {
  NUnitAssertFalseMethod() {
    exists(NUnitAssertClass c |
      this = c.getAFalseMethod() or
      this = c.getAnIsFalseMethod()
    )
  }
}

/** An NUnit `null` assertion method. */
class NUnitAssertNullMethod extends AssertNullMethod, NUnitAssertMethod {
  NUnitAssertNullMethod() {
    exists(NUnitAssertClass c |
      this = c.getANullMethod() or
      this = c.getAnIsNullMethod()
    )
  }
}

/** An NUnit non-`null` assertion method. */
class NUnitAssertNonNullMethod extends AssertNonNullMethod, NUnitAssertMethod {
  NUnitAssertNonNullMethod() {
    exists(NUnitAssertClass c |
      this = c.getANotNullMethod() or
      this = c.getAnIsNotNullMethod()
    )
  }
}

/** A method that forwards to another assertion method. */
class ForwarderAssertMethod extends AssertMethod {
  Assertion a;
  Parameter p;

  ForwarderAssertMethod() {
    p = this.getAParameter() and
    strictcount(AssignableDefinition def | def.getTarget() = p) = 1 and
    forex(ControlFlowElement body | body = this.getBody() |
      bodyAsserts(this, body, a) and
      a.getExpr() = p.getAnAccess()
    )
  }

  override int getAssertionIndex() { result = p.getPosition() }

  override Class getExceptionClass() {
    result = this.getUnderlyingAssertMethod().getExceptionClass()
  }

  /** Gets the underlying assertion method that is being forwarded to. */
  AssertMethod getUnderlyingAssertMethod() { result = a.getAssertMethod() }
}

pragma[noinline]
private predicate bodyAsserts(Callable c, ControlFlowElement body, Assertion a) {
  c.getBody() = body and
  body = getAnAssertingElement(a)
}

private ControlFlowElement getAnAssertingElement(Assertion a) {
  result = a
  or
  result = getAnAssertingStmt(a)
}

private Stmt getAnAssertingStmt(Assertion a) {
  result.(ExprStmt).getExpr() = getAnAssertingElement(a)
  or
  result.(BlockStmt).getFirstStmt() = getAnAssertingElement(a)
}

/** A method that forwards to a positive assertion method. */
class ForwarderAssertTrueMethod extends ForwarderAssertMethod, AssertTrueMethod {
  ForwarderAssertTrueMethod() { this.getUnderlyingAssertMethod() instanceof AssertTrueMethod }
}

/** A method that forwards to a negated assertion method. */
class ForwarderAssertFalseMethod extends ForwarderAssertMethod, AssertFalseMethod {
  ForwarderAssertFalseMethod() { this.getUnderlyingAssertMethod() instanceof AssertFalseMethod }
}

/** A method that forwards to a `null` assertion method. */
class ForwarderAssertNullMethod extends ForwarderAssertMethod, AssertNullMethod {
  ForwarderAssertNullMethod() { this.getUnderlyingAssertMethod() instanceof AssertNullMethod }
}

/** A method that forwards to a non-`null` assertion method. */
class ForwarderAssertNonNullMethod extends ForwarderAssertMethod, AssertNonNullMethod {
  ForwarderAssertNonNullMethod() { this.getUnderlyingAssertMethod() instanceof AssertNonNullMethod }
}

/** Holds if expression `e` appears in an assertion. */
predicate isExprInAssertion(Expr e) { e = any(Assertion a).getExpr().getAChildExpr*() }
