/** Provides classes for assertions. */
private import semmle.code.csharp.frameworks.system.Diagnostics
private import semmle.code.csharp.frameworks.test.VisualStudio

/** An assertion method. */
abstract class AssertMethod extends Method {
  /** Gets the index of the parameter being asserted. */
  abstract int getAssertionIndex();
}

/** A positive assertion method. */
abstract class AssertTrueMethod extends AssertMethod {
}

/** A negated assertion method. */
abstract class AssertFalseMethod extends AssertMethod {
}

/** A `null` assertion method. */
abstract class AssertNullMethod extends AssertMethod {
}

/** A non-`null` assertion method. */
abstract class AssertNonNullMethod extends AssertMethod {
}

/**
 * A `System.Diagnostics.Debug` assertion method.
 */
class SystemDiagnosticsDebugAssertTrueMethod extends AssertTrueMethod {
  SystemDiagnosticsDebugAssertTrueMethod() {
    this = any(SystemDiagnosticsDebugClass c).getAssertMethod()
  }

  override int getAssertionIndex() { result = 0 }
}

/** A Visual Studio assertion method. */
class VSTestAssertTrueMethod extends AssertTrueMethod {
  VSTestAssertTrueMethod() {
    this = any(VSTestAssertClass c).getIsTrueMethod()
  }

  override int getAssertionIndex() { result = 0 }
}

/** A Visual Studio negated assertion method. */
class VSTestAssertFalseMethod extends AssertFalseMethod {
  VSTestAssertFalseMethod() {
    this = any(VSTestAssertClass c).getIsFalseMethod()
  }

  override int getAssertionIndex() { result = 0 }
}

/** A Visual Studio `null` assertion method. */
class VSTestAssertNullMethod extends AssertNullMethod {
  VSTestAssertNullMethod() {
    this = any(VSTestAssertClass c).getIsNullMethod()
  }

  override int getAssertionIndex() { result = 0 }
}

/** A Visual Studio non-`null` assertion method. */
class VSTestAssertNonNullMethod extends AssertNonNullMethod {
  VSTestAssertNonNullMethod() {
    this = any(VSTestAssertClass c).getIsNotNullMethod()
  }

  override int getAssertionIndex() { result = 0 }
}

/** A method that forwards to another assertion method. */
class ForwarderAssertMethod extends AssertMethod {
  AssertMethod forwardee;
  int assertionIndex;

  ForwarderAssertMethod() {
    exists(AssignableDefinitions::ImplicitParameterDefinition def, ParameterRead pr |
      def.getParameter() = this.getParameter(assertionIndex) and
      pr = def.getAReachableRead() and
      pr.getAControlFlowNode().postDominates(this.getEntryPoint()) and
      forwardee.getParameter(forwardee.getAssertionIndex()).getAnAssignedArgument() = pr
    )
  }

  override int getAssertionIndex() { result = assertionIndex }

  /** Gets the underlying assertion method that is being forwarded to. */
  AssertMethod getUnderlyingAssertMethod() { result = forwardee }
}

/** A method that forwards to a positive assertion method. */
class ForwarderAssertTrueMethod extends ForwarderAssertMethod, AssertTrueMethod {
  ForwarderAssertTrueMethod() {
    this.getUnderlyingAssertMethod() instanceof AssertTrueMethod
  }
}

/** A method that forwards to a negated assertion method. */
class ForwarderAssertFalseMethod extends ForwarderAssertMethod, AssertFalseMethod {
  ForwarderAssertFalseMethod() {
    this.getUnderlyingAssertMethod() instanceof AssertFalseMethod
  }
}

/** A method that forwards to a `null` assertion method. */
class ForwarderAssertNullMethod extends ForwarderAssertMethod, AssertNullMethod {
  ForwarderAssertNullMethod() {
    this.getUnderlyingAssertMethod() instanceof AssertNullMethod
  }
}

/** A method that forwards to a non-`null` assertion method. */
class ForwarderAssertNonNullMethod extends ForwarderAssertMethod, AssertNonNullMethod {
  ForwarderAssertNonNullMethod() {
    this.getUnderlyingAssertMethod() instanceof AssertNonNullMethod
  }
}

/** Holds if expression `e` appears in an assertion. */
predicate isExprInAssertion(Expr e) {
  exists(MethodCall call, AssertMethod assertMethod |
    call.getTarget() = assertMethod |
    e = call.getArgument(assertMethod.getAssertionIndex()).getAChildExpr*()
  )
}
