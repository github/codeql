/** Provides classes which model the `chevron` package. */

import python
import semmle.python.web.HttpRequest
import experimental.semmle.python.templates.SSTISink

/** returns the Value representing `chevron.render` function */
deprecated Value theChevronRenderFunc() { result = Value::named("chevron.render") }

/**
 * A sink representing the `chevron.render` function call argument.
 *
 *  import chevron
 *  tmp = chevron.render(`sink`,{ 'key' : 'value' })
 */
deprecated class ChevronRenderSink extends SSTISink {
  override string toString() { result = "argument to chevron.render()" }

  ChevronRenderSink() {
    exists(CallNode call |
      call.getFunction() = theChevronRenderFunc().getAReference() and
      call.getArg(0) = this
    )
    // TODO: this should also detect :
    // import chevron
    // args = {
    //   'template': 'sink',
    //   'data': {
    //     'mustache': 'World'
    //   }
    // }
    // chevron.render(**args)
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
