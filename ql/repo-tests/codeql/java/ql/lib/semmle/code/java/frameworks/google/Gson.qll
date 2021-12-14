/**
 * Provides classes for working with the Gson framework.
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.android.Android
import semmle.code.java.frameworks.android.Intent

/** The class `com.google.gson.Gson`. */
class Gson extends RefType {
  Gson() { this.hasQualifiedName("com.google.gson", "Gson") }
}

/** The `fromJson` deserialization method. */
class GsonDeserializeMethod extends Method {
  GsonDeserializeMethod() {
    this.getDeclaringType() instanceof Gson and
    this.hasName("fromJson")
  }
}

/**
 * Holds if `intentNode` is an `Intent` used in the context `(T)intentNode.getParcelableExtra(...)` and
 * `parcelNode` is the corresponding parameter of `Parcelable.Creator<T> { public T createFromParcel(Parcel parcelNode) { }`,
 * where `T` is a concrete type implementing `Parcelable`.
 */
predicate intentFlowsToParcel(DataFlow::Node intentNode, DataFlow::Node parcelNode) {
  exists(MethodAccess getParcelableExtraCall, CreateFromParcelMethod cfpm, Type createdType |
    intentNode.asExpr() = getParcelableExtraCall.getQualifier() and
    getParcelableExtraCall.getMethod() instanceof IntentGetParcelableExtraMethod and
    DataFlow::localExprFlow(getParcelableExtraCall, any(Expr e | e.getType() = createdType)) and
    parcelNode.asParameter() = cfpm.getParameter(0) and
    cfpm.getReturnType() = createdType
  )
}
