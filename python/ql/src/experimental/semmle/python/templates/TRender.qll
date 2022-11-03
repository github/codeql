/** Provides classes which model the `TRender` package. */

import python
import semmle.python.web.HttpRequest
import experimental.semmle.python.templates.SSTISink

/** returns the ClassValue representing `trender.TRender` */
ClassValue theTRenderTemplateClass() { result = Value::named("trender.TRender") }

/**
 * Sink representing the `trender.TRender` class instantiation argument.
 *
 *  from trender import TRender
 *  template = TRender(`sink`)
 */
class TRenderTemplateSink extends SSTISink {
  override string toString() { result = "argument to trender.TRender()" }

  TRenderTemplateSink() {
    exists(CallNode call |
      call.getFunction().pointsTo(theTRenderTemplateClass()) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
