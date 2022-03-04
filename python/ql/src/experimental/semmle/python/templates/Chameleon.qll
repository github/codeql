/** Provides classes which model the `Chameleon` package. */

import python
import semmle.python.web.HttpRequest
import experimental.semmle.python.templates.SSTISink

/** returns the ClassValue representing `chameleon.PageTemplate` */
deprecated ClassValue theChameleonPageTemplateClass() {
  result = Value::named("chameleon.PageTemplate")
}

/**
 * A sink representing the `chameleon.PageTemplate` class instantiation argument.
 *
 *  from chameleon import PageTemplate
 *  template = PageTemplate(`sink`)
 */
deprecated class ChameleonTemplateSink extends SSTISink {
  override string toString() { result = "argument to Chameleon.PageTemplate()" }

  ChameleonTemplateSink() {
    exists(CallNode call |
      call.getFunction().pointsTo(theChameleonPageTemplateClass()) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
