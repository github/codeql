private import csharp
private import semmle.code.csharp.commons.Collections as Collections
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import CaptureModelsSpecific as Specific
private import CaptureModels

/**
 * A class of callables that are relevant generating summaries for based
 * on the Theorems for Free approach.
 */
class TheoremTargetApi extends Specific::TargetApiSpecific {
  TheoremTargetApi() { Specific::isRelevantForTheoremModels(this) }

  private predicate isClassTypeParameter(TypeParameter t) {
    t = this.getDeclaringType().(UnboundGeneric).getATypeParameter()
  }

  private predicate isMethodTypeParameter(TypeParameter t) {
    t = this.(UnboundGeneric).getATypeParameter()
  }

  bindingset[t]
  private string getAccess(TypeParameter t) {
    exists(string access |
      if Collections::isCollectionType(this.getDeclaringType())
      then access = ".Element"
      else access = ""
    |
      result = Specific::qualifierString() + ".SyntheticField[Arg" + t.getName() + "]" + access
    )
  }

  private predicate returns(TypeParameter t) { this.getReturnType() = t }

  private predicate parameter(TypeParameter t, Parameter p) {
    p = this.getAParameter() and
    p.getType() = t
  }

  /**
   * Gets the string representation of a summary for `this`, where this has a signature like
   * this : T -> unit
   * where T is type parameter for the class declaring `this`.
   */
  private string getSetterSummary() {
    exists(TypeParameter t, Parameter p |
      this.isClassTypeParameter(t) and
      this.getReturnType() instanceof VoidType and
      this.parameter(t, p)
    |
      result = asTaintModel(this, Specific::parameterAccess(p), this.getAccess(t))
    )
  }

  /**
   * Gets the string representation of a summary for `this`, where this has a signature like
   * this : unit -> T
   * where T is type parameter for the class declaring `this`.
   */
  private string getGetterSummary() {
    exists(TypeParameter t |
      this.isClassTypeParameter(t) and
      this.returns(t) and
      not this.parameter(t, _)
    |
      result = asTaintModel(this, this.getAccess(t), "ReturnValue")
    )
  }

  /**
   * Gets the string representation of a summary for `this`, where this has a signature like
   * this : T -> T
   */
  private string getTransformSummary() {
    exists(TypeParameter t, Parameter p |
      (this.isClassTypeParameter(t) or this.isMethodTypeParameter(t)) and
      this.returns(t) and
      this.parameter(t, p)
    |
      result = asTaintModel(this, Specific::parameterAccess(p), "ReturnValue")
    )
  }

  /**
   * Gets the string representation of a summary for `this`, where this has a signature like
   * this : (T -> V1) -> V2
   * where T is type parameter for the class declaring `this`.
   */
  private string getApplySummary() {
    exists(TypeParameter t, Parameter p1, Parameter p2 |
      this.isClassTypeParameter(t) and
      p1 = this.getAParameter() and
      p2 = p1.getType().(SystemLinqExpressions::DelegateExtType).getDelegateType().getAParameter() and
      p2.getType() = t
    |
      result =
        asTaintModel(this, this.getAccess(t),
          Specific::parameterAccess(p1) + ".Parameter[" + p2.getPosition() + "]")
    )
  }

  /**
   * Gets the string representation of all summaries based on the Theorems for Free approach.
   */
  string getSummaries() {
    result =
      [
        this.getSetterSummary(), this.getGetterSummary(), this.getTransformSummary(),
        this.getApplySummary()
      ]
  }
}

/**
 * Returns the Theorems for Free summaries for `api`.
 */
string captureFlow(TheoremTargetApi api) { result = api.getSummaries() }
