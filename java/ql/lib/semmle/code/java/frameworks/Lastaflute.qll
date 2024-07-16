/**
 * Provides classes and predicates for working with the Lastaflute web framework.
 */

import java
import semmle.code.java.dataflow.FlowSources

/**
 * The `org.lastaflute.web.Execute` annotation.
 */
class LastafluteExecuteAnnotation extends Annotation {
  LastafluteExecuteAnnotation() { this.getType().hasQualifiedName("org.lastaflute.web", "Execute") }
}

/**
 * The parameter of a method defining a URL handler using the Lastaflute framework.
 */
class LastafluteHandlerParameterSource extends RemoteFlowSource {
  LastafluteHandlerParameterSource() {
    exists(Parameter p | p.getCallable().getAnAnnotation() instanceof LastafluteExecuteAnnotation |
      p = this.asParameter()
    )
  }

  override string getSourceType() { result = "Lastaflute handler parameter" }
}
