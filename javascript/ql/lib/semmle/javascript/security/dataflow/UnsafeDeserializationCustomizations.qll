/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unsafe deserialization, as well as extension points for
 * adding your own.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources

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

  /** A source of remote user input, considered as a flow source for unsafe deserialization. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * An expression passed to one of the unsafe load functions of the `js-yaml` package.
   */
  class JsYamlUnsafeLoad extends Sink {
    JsYamlUnsafeLoad() {
      exists(DataFlow::ModuleImportNode mi | mi.getPath() = "js-yaml" |
        // the first argument to a call to `load` or `loadAll`
        exists(string n | n = "load" or n = "loadAll" | this = mi.getAMemberCall(n).getArgument(0))
        or
        // the first argument to a call to `safeLoad` or `safeLoadAll` where
        // the schema is specified to be `DEFAULT_FULL_SCHEMA`
        exists(string n, DataFlow::CallNode c, DataFlow::Node fullSchema |
          n = "safeLoad" or n = "safeLoadAll"
        |
          c = mi.getAMemberCall(n) and
          this = c.getArgument(0) and
          fullSchema = c.getOptionArgument(c.getNumArgument() - 1, "schema") and
          mi.getAPropertyRead("DEFAULT_FULL_SCHEMA").flowsTo(fullSchema)
        )
      )
    }
  }
}
