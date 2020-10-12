/**
 * Provides C# specific classes and predicates for definining data-flow through frameworks.
 */

private import csharp
private import semmle.code.csharp.frameworks.system.linq.Expressions

module Private {
  predicate hasDelegateArgumentPosition(FrameworkCallable c, int i) {
    exists(DelegateType dt |
      dt = c.getParameter(i).getType().(SystemLinqExpressions::DelegateExtType).getDelegateType()
    |
      not dt.getReturnType() instanceof VoidType
    )
  }

  predicate hasDelegateArgumentPosition2(FrameworkCallable c, int i, int j) {
    exists(DelegateType dt |
      dt = c.getParameter(i).getType().(SystemLinqExpressions::DelegateExtType).getDelegateType()
    |
      exists(dt.getParameter(j))
    )
  }

  newtype TSummaryInput =
    TQualifierSummaryInput() or
    TArgumentSummaryInput(int i) { i = any(Parameter p).getPosition() } or
    TDelegateSummaryInput(int i) { hasDelegateArgumentPosition(_, i) }

  newtype TSummaryOutput =
    TQualifierSummaryOutput() or
    TReturnSummaryOutput() or
    TArgumentSummaryOutput(int i) { exists(FrameworkCallable c | exists(c.getParameter(i))) } or
    TDelegateSummaryOutput(int i, int j) { hasDelegateArgumentPosition2(_, i, j) }
}

private import Private

module Public {
  /** An unbound callable. */
  class FrameworkCallable extends Callable {
    FrameworkCallable() { this = this.getSourceDeclaration() }
  }

  /** A flow-summary input specification. */
  class SummaryInput extends TSummaryInput {
    /** Gets a textual representation of this input specification. */
    final string toString() {
      this = TQualifierSummaryInput() and
      result = "qualifier"
      or
      exists(int i |
        this = TArgumentSummaryInput(i) and
        result = "argument " + i
        or
        this = TDelegateSummaryInput(i) and
        result = "output from argument " + i
      )
    }
  }

  /** A flow-summary output specification. */
  class SummaryOutput extends TSummaryOutput {
    /** Gets a textual representation of this flow sink specification. */
    final string toString() {
      this = TQualifierSummaryOutput() and
      result = "qualifier"
      or
      this = TReturnSummaryOutput() and
      result = "return"
      or
      exists(int i |
        this = TArgumentSummaryOutput(i) and
        result = "argument " + i
      )
      or
      exists(int delegateIndex, int parameterIndex |
        this = TDelegateSummaryOutput(delegateIndex, parameterIndex) and
        result = "parameter " + parameterIndex + " of argument " + delegateIndex
      )
    }
  }
}

private import Public
