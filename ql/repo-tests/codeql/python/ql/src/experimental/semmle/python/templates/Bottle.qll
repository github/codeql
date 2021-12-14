/** Provides classes which model the `bottle` package. */

import python
import semmle.python.web.HttpRequest
import experimental.semmle.python.templates.SSTISink

/** returns the ClassValue representing `bottle.SimpleTemplate` */
ClassValue theBottleSimpleTemplateClass() { result = Value::named("bottle.SimpleTemplate") }

/**
 * Sink representing the `bottle.SimpleTemplate` class instantiation argument.
 *
 *  from bottle import SimpleTemplate
 *  template = SimpleTemplate(`sink`)
 */
class BottleSimpleTemplateSink extends SSTISink {
  override string toString() { result = "argument to bottle.SimpleTemplate()" }

  BottleSimpleTemplateSink() {
    exists(CallNode call |
      call.getFunction().pointsTo(theBottleSimpleTemplateClass()) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}

/**
 * Sink representing the `bottle.template` function call argument.
 *
 *  from bottle import template
 *  tmp = template(`sink`)
 */
class BottleTemplateSink extends SSTISink {
  override string toString() { result = "argument to bottle.template()" }

  BottleTemplateSink() {
    exists(CallNode call |
      call.getFunction() = theBottleModule().attr("template").getAReference() and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
