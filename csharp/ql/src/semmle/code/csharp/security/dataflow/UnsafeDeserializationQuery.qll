/**
 * Provides a taint-tracking configuration for reasoning about uncontrolled data
 * in calls to unsafe deserializers (XML, JSON, XAML).
 */

import csharp

module UnsafeDeserialization {
  private import semmle.code.csharp.security.dataflow.flowsources.Remote
  private import semmle.code.csharp.serialization.Deserializers

  /**
   * A data flow source for unsafe deserialization vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for unsafe deserialization vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for unsafe deserialization vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for reasoning about unsafe deserialization.
   */
  class TaintTrackingConfig extends TaintTracking::Configuration {
    TaintTrackingConfig() { this = "UnsafeDeserialization" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  class RemoteSource extends Source {
    RemoteSource() { this instanceof RemoteFlowSource }
  }

  /** A call to an unsafe deserializer. */
  class UnsafeDeserializerSink extends Sink {
    UnsafeDeserializerSink() {
      exists(Call c |
        this.asExpr() = c.getAnArgument() and
        c.getTarget() instanceof UnsafeDeserializer
      )
    }
  }

  private class JavaScriptSerializerClass extends Class {
    JavaScriptSerializerClass() {
      this.hasQualifiedName("System.Web.Script.Serialization.JavaScriptSerializer")
    }
  }

  /**
   * An unsafe use of a JavaScript deserializer. That is, a use with a custom type-resolver
   * (constructor parameter).
   */
  class JavaScriptSerializerSink extends Sink {
    JavaScriptSerializerSink() {
      exists(ObjectCreation oc |
        oc.getTarget().getDeclaringType() instanceof JavaScriptSerializerClass and
        oc.getTarget().getNumberOfParameters() > 0 and
        exists(MethodCall mc, Method m |
          m = mc.getTarget() and
          m.getDeclaringType() instanceof JavaScriptSerializerClass and
          (
            m.hasName("Deserialize") or
            m.hasName("DeserializeObject")
          ) and
          this.asExpr() = mc.getAnArgument() and
          DataFlow::localFlow(DataFlow::exprNode(oc), DataFlow::exprNode(mc.getQualifier()))
        )
      )
    }
  }
}
