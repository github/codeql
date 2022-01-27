import semmle.code.csharp.dataflow.FlowSummary
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl::Private::TestOutput

abstract class IncludeSummarizedCallable extends RelevantSummarizedCallable {
  IncludeSummarizedCallable() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic()
  }

  /** Gets the qualified parameter types of this callable as a comma-separated string. */
  private string parameterQualifiedTypeNamesToString() {
    result =
      concat(Parameter p, int i |
        p = this.getParameter(i)
      |
        p.getType().getQualifiedName(), "," order by i
      )
  }

  /** Holds if the summary should apply for all overrides of this. */
  predicate isBaseCallableOrPrototype() {
    this.getDeclaringType() instanceof Interface
    or
    exists(Modifiable m | m = [this.(Modifiable), this.(Accessor).getDeclaration()] |
      m.isAbstract()
      or
      this.getDeclaringType().(Modifiable).isAbstract() and m.(Virtualizable).isVirtual()
    )
  }

  /** Gets a string representing, whether the summary should apply for all overrides of this. */
  private string getCallableOverride() {
    if this.isBaseCallableOrPrototype() then result = "true" else result = "false"
  }

  /** Gets a string representing the callable in semi-colon separated format for use in flow summaries. */
  final override string getCallableCsv() {
    exists(string namespace, string type |
      this.getDeclaringType().hasQualifiedName(namespace, type) and
      result =
        namespace + ";" + type + ";" + this.getCallableOverride() + ";" + this.getName() + ";" + "("
          + this.parameterQualifiedTypeNamesToString() + ")"
    )
  }
}
