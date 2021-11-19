import semmle.code.csharp.dataflow.FlowSummary
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl::Private::TestOutput

abstract class IncludeSummarizedCallable extends RelevantSummarizedCallable {
  /** Gets the qualified parameter types of this callable as a comma-separated string */
  private string parameterQualifiedTypeNamesToString() {
    result =
      concat(int i |
        exists(this.getParameter(i))
      |
        this.getParameter(i).getType().getQualifiedName(), ", " order by i
      )
  }

  /* Gets a string representation of the input type signature of callable */
  private string getCallableSignature() {
    result = "(" + parameterQualifiedTypeNamesToString() + ")"
  }

  /* Gets a string representing, whether the declaring type is an interface */
  private string getCallableOverride() {
    if
      this.getDeclaringType() instanceof Interface or
      this.(Modifiable).isAbstract()
    then result = "true"
    else result = "false"
  }

  /** Gets a string representing the callable in semi-colon separated format for use in flow summaries. */
  final override string getCallableCsv() {
    exists(string namespace, string type |
      this.getDeclaringType().hasQualifiedName(namespace, type) and
      result =
        namespace + ";" + type + ";" + this.getCallableOverride() + ";" + this.getName() + ";" +
          this.getCallableSignature()
    )
  }
}
