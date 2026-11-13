/**
 * Provides classes and predicates for identifying sensitive data.
 *
 * 'Sensitive' data is anything that should not be sent in unencrypted form. This library tries to
 * guess where sensitive data may either be stored in a variable or produced by a method.
 */

import unified
import codeql.concepts.internal.SensitiveDataHeuristics
private import codeql.unified.internal.typeinference.TypeInference as TypeInference

/**
 * A data flow node that might contain sensitive data.
 */
cached
abstract class SensitiveData extends DataFlow::Node {
  /**
   * Gets the classification of sensitive data this expression might contain.
   */
  cached
  abstract SensitiveDataClassification getClassification();
}

/**
 * An identifier that might contain sensitive data.
 */
private class SensitiveDataIdentifier extends SensitiveData {
  SensitiveDataClassification classification;

  SensitiveDataIdentifier() {
    exists(IdentifierExpr e | e = this.asExpr() |
      HeuristicNames::nameIndicatesSensitiveData(e.getValue(), classification)
    )
  }

  override SensitiveDataClassification getClassification() { result = classification }
}

private Expr memberAccessParent(MemberAccessExpr e) { result = e.getParent() }

/**
 * A member access that might contain sensitive data. This includes a member itself and
 * components of a receiver chain, for example:
 * ```
 * object.password
 * password.value
 * password.getValue()
 * ```
 */
private class SensitiveDataMemberAccess extends SensitiveData {
  SensitiveDataClassification classification;

  SensitiveDataMemberAccess() {
    exists(MemberAccessExpr e | memberAccessParent*(e) = this.asExpr() |
      HeuristicNames::nameIndicatesSensitiveData(e.getMemberName(), classification)
    )
  }

  override SensitiveDataClassification getClassification() { result = classification }
}

/**
 * A function call that might produce sensitive data.
 */
private class SensitiveDataCall extends SensitiveData {
  SensitiveDataClassification classification;

  SensitiveDataCall() {
    exists(CallExpr call, string name |
      call = this.asExpr() and
      name = TypeInference::resolveCallTarget(call).(Member).getNameNode().getValue() and
      HeuristicNames::nameIndicatesSensitiveData(name, classification)
    )
  }

  override SensitiveDataClassification getClassification() { result = classification }
}
