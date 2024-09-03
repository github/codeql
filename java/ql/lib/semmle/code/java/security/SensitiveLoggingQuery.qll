/** Provides configurations for sensitive logging queries. */

import java
private import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.SensitiveActions
import semmle.code.java.frameworks.android.Compose
private import semmle.code.java.security.Sanitizers

/** A data flow source node for sensitive logging sources. */
abstract class SensitiveLoggerSource extends DataFlow::Node { }

/** A variable that may hold sensitive information, judging by its name. */
class VariableWithSensitiveName extends Variable {
  VariableWithSensitiveName() {
    exists(string name | name = this.getName() |
      name.regexpMatch(getCommonSensitiveInfoRegex()) and
      not name.regexpMatch(getCommonSensitiveInfoFPRegex())
    )
  }
}

/** A reference to a variable that may hold sensitive information, judging by its name. */
class CredentialExpr extends VarAccess {
  CredentialExpr() {
    this.getVariable() instanceof VariableWithSensitiveName and
    not this instanceof CompileTimeConstantExpr
  }
}

private class CredentialExprSource extends SensitiveLoggerSource {
  CredentialExprSource() { this.asExpr() instanceof CredentialExpr }
}

/** An instantiation of a (reflexive, transitive) subtype of `java.lang.reflect.Type`. */
private class TypeType extends RefType {
  pragma[nomagic]
  TypeType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.lang.reflect", "Type")
  }
}

/** A data-flow configuration for identifying potentially-sensitive data flowing to a log output. */
module SensitiveLoggerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof SensitiveLoggerSource }

  predicate isSink(DataFlow::Node sink) { sinkNode(sink, "log-injection") }

  predicate isBarrier(DataFlow::Node sanitizer) {
    sanitizer.asExpr() instanceof LiveLiteral or
    sanitizer instanceof SimpleTypeSanitizer or
    sanitizer.getType() instanceof TypeType
  }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

module SensitiveLoggerFlow = TaintTracking::Global<SensitiveLoggerConfig>;
