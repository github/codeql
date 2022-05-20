/** Provides classes which model the `Jinja2` package. */

import python
import semmle.python.web.HttpRequest
import experimental.semmle.python.templates.SSTISink

/** returns the ClassValue representing `jinja2.Template` */
deprecated ClassValue theJinja2TemplateClass() { result = Value::named("jinja2.Template") }

/** returns the ClassValue representing `jinja2.Template` */
deprecated Value theJinja2FromStringValue() { result = Value::named("jinja2.from_string") }

/**
 * A sink representing the `jinja2.Template` class instantiation argument.
 *
 *  from jinja2 import Template
 *  template = Template(`sink`)
 */
deprecated class Jinja2TemplateSink extends SSTISink {
  override string toString() { result = "argument to jinja2.Template()" }

  Jinja2TemplateSink() {
    exists(CallNode call |
      call.getFunction().pointsTo(theJinja2TemplateClass()) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}

/**
 * A sink representing the `jinja2.from_string` function call argument.
 *
 *  from jinja2 import from_string
 *  template = from_string(`sink`)
 */
deprecated class Jinja2FromStringSink extends SSTISink {
  override string toString() { result = "argument to jinja2.from_string()" }

  Jinja2FromStringSink() {
    exists(CallNode call |
      call.getFunction().pointsTo(theJinja2FromStringValue()) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
