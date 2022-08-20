/** Provides classes which model templates in the`flask` package. */

import python
import semmle.python.web.HttpRequest
import experimental.semmle.python.templates.SSTISink

deprecated Value theFlaskRenderTemplateClass() {
  result = Value::named("flask.render_template_string")
}

/**
 * A sink representng `flask.render_template_string` function call argument.
 *
 *  from flask import render_template_string
 *  render_template_string(`sink`)
 */
deprecated class FlaskTemplateSink extends SSTISink {
  override string toString() { result = "argument to flask.render_template_string()" }

  FlaskTemplateSink() {
    exists(CallNode call |
      call.getFunction().pointsTo(theFlaskRenderTemplateClass()) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
