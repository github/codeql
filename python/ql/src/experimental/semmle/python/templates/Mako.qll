/** Provides classes which model the `Mako` package. */

import python
import semmle.python.web.HttpRequest
import experimental.semmle.python.templates.SSTISink

/** returns the ClassValue representing `mako.template.Template` */
deprecated ClassValue theMakoTemplateClass() { result = Value::named("mako.template.Template") }

/**
 * A sink representing the `mako.template.Template` class instantiation argument.
 *
 *  from mako.template import Template
 *  mytemplate = Template("hello world!")
 */
deprecated class MakoTemplateSink extends SSTISink {
  override string toString() { result = "argument to mako.template.Template()" }

  MakoTemplateSink() {
    exists(CallNode call |
      call.getFunction().pointsTo(theMakoTemplateClass()) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
