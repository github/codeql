/**
 * Contains configuration for tracking down unsafe deserialization (XML, JSON, XAML)
 */

import csharp

module UnsafeDeserializersDataFlow {
  private import semmle.code.csharp.dataflow.flowsources.Remote
  private import semmle.code.csharp.dataflow.flowsources.Remote
  private import Deserializers

  /**
   * A data flow source for unsafe deserialization vulnerabilities.
   */
  abstract class UnsafeDeserializationSource extends DataFlow::Node { }

  /**
   * A data flow sink for unsafe deserialization vulnerabilities.
   */
  abstract class UnsafeDeserializationSink extends DataFlow::Node { }

  /**
   * A sanitizer for unsafe deserialization vulnerabilities.
   */
  abstract class UnsafeDeserializationSanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for reasoning about unsafe deserialization.
   */
  class UnsafeDeserializationTrackingConfig extends TaintTracking::Configuration {
    UnsafeDeserializationTrackingConfig() { this = "UnsafeDeserializationTrackingConfig" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof UnsafeDeserializationSource or
      source instanceof RemoteFlowSource
    }

    override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeDeserializationSink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof UnsafeDeserializationSanitizer
    }
  }

  /**
   * Call to one of unsafe deserializers
   */
  class UnsafeDeserializerSink extends UnsafeDeserializationSink {
    UnsafeDeserializerSink() {
      exists(Call c |
        this.asExpr() = c.getAnArgument() and
        c.getTarget() instanceof UnsafeDeserializer
      )
    }
  }

  /**
   * JavaScript deserializer is unsafe if used with with a custom type-resolver (constructor parameter)
   */
  class JavaScriptSerializerSink extends UnsafeDeserializationSink {
    JavaScriptSerializerSink() {
      exists(ObjectCreation oc |
        oc
            .getTarget()
            .getDeclaringType()
            .hasQualifiedName("System.Web.Script.Serialization.JavaScriptSerializer") and
        oc.getTarget().getNumberOfParameters() > 0 and
        exists(MethodCall mc |
          (
            mc
                .getTarget()
                .hasQualifiedName("System.Web.Script.Serialization.JavaScriptSerializer",
                  "Deserialize") or
            mc
                .getTarget()
                .hasQualifiedName("System.Web.Script.Serialization.JavaScriptSerializer",
                  "DeserializeObject")
          ) and
          this.asExpr() = mc.getAnArgument() and
          DataFlow::localFlow(DataFlow::exprNode(oc), DataFlow::exprNode(mc.getQualifier()))
        )
      )
    }
  }
}
