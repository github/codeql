/** Provides sink models relating to SpEL injection vulnerabilities. */

import semmle.code.java.dataflow.ExternalFlow

private class SpelExpressionEvaluationModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.springframework.expression;Expression;true;getValue;;;Argument[-1];spel",
        "org.springframework.expression;Expression;true;getValueTypeDescriptor;;;Argument[-1];spel",
        "org.springframework.expression;Expression;true;getValueType;;;Argument[-1];spel",
        "org.springframework.expression;Expression;true;setValue;;;Argument[-1];spel"
      ]
  }
}
