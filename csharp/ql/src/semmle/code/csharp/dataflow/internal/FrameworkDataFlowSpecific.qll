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
    TParameterSummaryInput(int i) { i in [-1, any(Parameter p).getPosition()] } or
    TDelegateSummaryInput(int i) { hasDelegateArgumentPosition(_, i) }

  newtype TSummaryOutput =
    TReturnSummaryOutput() or
    TParameterSummaryOutput(int i) {
      i in [-1, any(FrameworkCallable c).getAParameter().getPosition()]
    } or
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
      exists(int i |
        this = TParameterSummaryInput(i) and
        result = "parameter " + i
        or
        this = TDelegateSummaryInput(i) and
        result = "deleget output from parameter " + i
      )
    }
  }

  /** A flow-summary output specification. */
  class SummaryOutput extends TSummaryOutput {
    /** Gets a textual representation of this flow sink specification. */
    final string toString() {
      this = TReturnSummaryOutput() and
      result = "return"
      or
      exists(int i |
        this = TParameterSummaryOutput(i) and
        result = "parameter " + i
      )
      or
      exists(int delegateIndex, int parameterIndex |
        this = TDelegateSummaryOutput(delegateIndex, parameterIndex) and
        result = "parameter " + parameterIndex + " of delegate parameter " + delegateIndex
      )
    }
  }
}

private import Public
