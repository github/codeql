private import csharp
private import semmle.code.csharp.frameworks.system.collections.Generic as GenericCollections
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import CaptureModelsSpecific as Specific
private import CaptureModels

/**
 * Holds if `t` is a subtype (reflexive/transitive) of `IEnumerable<T>`, where `T` = `tp`.
 */
private predicate isGenericCollectionType(ValueOrRefType t, TypeParameter tp) {
  exists(ConstructedGeneric t2 |
    t2 = t.getABaseType*() and
    t2.getUnboundDeclaration() instanceof
      GenericCollections::SystemCollectionsGenericIEnumerableTInterface and
    tp = t2.getATypeArgument()
  )
}

/**
 * A class of callables that are relevant generating summaries for based
 * on the Theorems for Free approach.
 */
class TheoremTargetApi extends Specific::TargetApiSpecific {
  TheoremTargetApi() { Specific::isRelevantForTheoremModels(this) }

  private predicate isClassTypeParameter(TypeParameter t) {
    t = this.getDeclaringType().(UnboundGeneric).getATypeParameter()
  }

  bindingset[t]
  private string getAccess(TypeParameter t) {
    exists(string access |
      if isGenericCollectionType(this.getDeclaringType(), t)
      then access = ".Element"
      else access = ".SyntheticField[ArgType" + t.getIndex() + "]"
    |
      result = Specific::qualifierString() + access
    )
  }

  bindingset[t]
  private string getReturnAccess(TypeParameter t) {
    exists(string access |
      (
        if isGenericCollectionType(this.getReturnType(), t)
        then access = ".Element"
        else access = ""
      ) and
      result = "ReturnValue" + access
    )
  }

  /**
   * Holds if `this` returns a value of type `t` or a collection of type `t`.
   */
  private predicate returns(TypeParameter t) {
    this.getReturnType() = t or isGenericCollectionType(this.getReturnType(), t)
  }

  /**
   * Holds if `this` has a parameter `p`, which is of type `t`
   * or collection of type `t`.
   */
  private predicate parameter(TypeParameter t, Parameter p) {
    p = this.getAParameter() and
    (
      // Parameter of type t
      p.getType() = t
      or
      // Parameter is a collection of type t
      isGenericCollectionType(p.getType(), t)
    )
  }

  /**
   * Gets the string representation of a summary for `this`, where this has a signature like
   * this : T -> S
   * where T is type parameter for the class declaring `this`.
   * Important cases are S = unit (setter) and S = T (both getter and setter).
   */
  private string getSetterSummary() {
    exists(TypeParameter t, Parameter p |
      this.isClassTypeParameter(t) and
      this.parameter(t, p)
    |
      result = asValueModel(this, Specific::parameterAccess(p), this.getAccess(t))
    )
  }

  /**
   * Gets the string representation of a summary for `this`, where this has a signature like
   * this : S -> T
   * where T is type parameter for the class declaring `this`.
   * Important cases are S = unit (getter) and S = T (both getter and setter).
   */
  private string getGetterSummary() {
    exists(TypeParameter t |
      this.isClassTypeParameter(t) and
      this.returns(t)
    |
      result = asValueModel(this, this.getAccess(t), this.getReturnAccess(t))
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
        asValueModel(this, this.getAccess(t),
          Specific::parameterAccess(p1) + ".Parameter[" + p2.getPosition() + "]")
    )
  }

  /**
   * Gets the string representation of all summaries based on the Theorems for Free approach.
   */
  string getSummaries() {
    result = [this.getSetterSummary(), this.getGetterSummary(), this.getApplySummary()]
  }
}

/**
 * Returns the Theorems for Free summaries for `api`.
 */
string captureFlow(TheoremTargetApi api) { result = api.getSummaries() }
