/**
 * Provides classes and predicates for identifying sensitive data.
 *
 * 'Sensitive' data is anything that should not be sent in unencrypted form. This library tries to
 * guess where sensitive data may either be stored in a variable or produced by a method.
 */

import rust
import internal.SensitiveDataHeuristics
private import codeql.rust.dataflow.DataFlow

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
 * A function call or enum variant data flow node that might produce sensitive data.
 */
private class SensitiveDataCall extends SensitiveData {
  SensitiveDataClassification classification;

  SensitiveDataCall() {
    exists(CallExprBase call, string name |
      call = this.asExpr().getExpr() and
      name =
        [
          call.getStaticTarget().(Function).getName().getText(),
          call.(CallExpr).getVariant().getName().getText(),
        ] and
      HeuristicNames::nameIndicatesSensitiveData(name, classification)
    )
  }

  override SensitiveDataClassification getClassification() { result = classification }
}

/**
 * A variable access data flow node that might be sensitive data.
 */
private class SensitiveVariableAccess extends SensitiveData {
  SensitiveDataClassification classification;

  SensitiveVariableAccess() {
    HeuristicNames::nameIndicatesSensitiveData(this.asExpr()
          .getExpr()
          .(VariableAccess)
          .getVariable()
          .(Variable)
          .getText(), classification)
  }

  override SensitiveDataClassification getClassification() { result = classification }
}

private Expr fieldExprParentField(FieldExpr fe) { result = fe.getParentNode() }

/**
 * A field access data flow node that might be sensitive data.
 */
private class SensitiveFieldAccess extends SensitiveData {
  SensitiveDataClassification classification;

  SensitiveFieldAccess() {
    exists(FieldExpr fe | fieldExprParentField*(fe) = this.asExpr().getExpr() |
      HeuristicNames::nameIndicatesSensitiveData(fe.getIdentifier().getText(), classification)
    )
  }

  override SensitiveDataClassification getClassification() { result = classification }
}
