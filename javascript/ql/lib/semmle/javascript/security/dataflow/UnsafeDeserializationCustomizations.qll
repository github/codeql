/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unsafe deserialization, as well as extension points for
 * adding your own.
 */

import javascript

module UnsafeDeserialization {
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
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  private API::Node unsafeYamlSchema() {
    result = API::moduleImport("js-yaml").getMember("DEFAULT_FULL_SCHEMA") // from older versions
    or
    result = API::moduleImport("js-yaml-js-types").getMember(["all", "function"])
    or
    result = unsafeYamlSchema().getMember("extend").getReturn()
    or
    exists(API::CallNode call |
      call.getAParameter().refersTo(unsafeYamlSchema()) and
      call.getCalleeName() = "extend" and
      result = call.getReturn()
    )
  }

  /**
   * An expression passed to one of the unsafe load functions of the `js-yaml` package.
   *
   * `js-yaml` since v4 defaults to being safe, but is unsafe when invoked with a schema
   * that permits unsafe values.
   */
  class JsYamlUnsafeLoad extends Sink {
    JsYamlUnsafeLoad() {
      exists(API::CallNode call |
        // Note: we include the old 'safeLoad' and 'safeLoadAll' functon because they were also unsafe when invoked with an unsafe schema.
        call =
          API::moduleImport("js-yaml")
              .getMember(["load", "loadAll", "safeLoad", "safeLoadAll"])
              .getACall() and
        call.getAParameter().getMember("schema").refersTo(unsafeYamlSchema()) and
        this = call.getArgument(0)
      )
    }
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("unsafe-deserialization").asSink() }
  }
}
