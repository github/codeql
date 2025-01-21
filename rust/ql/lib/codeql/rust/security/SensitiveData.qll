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
 * A function that might produce sensitive data.
 */
private class SensitiveDataFunction extends Function {
  SensitiveDataClassification classification;

  SensitiveDataFunction() {
    HeuristicNames::nameIndicatesSensitiveData(this.getName().getText(), classification)
  }

  SensitiveDataClassification getClassification() { result = classification }
}

/**
 * A function call data flow node that might produce sensitive data.
 */
private class SensitiveDataCall extends SensitiveData {
  SensitiveDataClassification classification;

  SensitiveDataCall() {
    classification =
      this.asExpr()
          .getAstNode()
          .(CallExprBase)
          .getStaticTarget()
          .(SensitiveDataFunction)
          .getClassification()
  }

  override SensitiveDataClassification getClassification() { result = classification }
}

/**
 * A variable that might contain sensitive data.
 */
private class SensitiveDataVariable extends Variable {
  SensitiveDataClassification classification;

  SensitiveDataVariable() {
    HeuristicNames::nameIndicatesSensitiveData(this.getName(), classification)
  }

  SensitiveDataClassification getClassification() { result = classification }
}

/**
 * A variable access data flow node that might produce sensitive data.
 */
private class SensitiveVariableAccess extends SensitiveData {
  SensitiveDataClassification classification;

  SensitiveVariableAccess() {
    classification =
      this.asExpr()
          .getAstNode()
          .(VariableAccess)
          .getVariable()
          .(SensitiveDataVariable)
          .getClassification()
  }

  override SensitiveDataClassification getClassification() { result = classification }
}
