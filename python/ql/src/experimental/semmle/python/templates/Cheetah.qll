/** Provides classes which model the `Cheetah3` package. */

import python
import semmle.python.web.HttpRequest
import experimental.semmle.python.templates.SSTISink

/** returns the ClassValue representing `Cheetah.Template.Template` */
ClassValue theCheetahTemplateClass() { result = Value::named("Cheetah.Template.Template") }

/**
 * Sink representing the instantiation argument of any class which derives from
 * the `Cheetah.Template.Template` class .
 *
 *  from Cheetah.Template import Template
 *  class Template3(Template):
 *    title = 'Hello World Example!'
 *    contents = 'Hello World!'
 *  t3 = Template3("sink")
 *
 * This will also detect cases of the following type :
 *
 *  from Cheetah.Template import Template
 *  t3 = Template("sink")
 */
class CheetahTemplateInstantiationSink extends SSTISink {
  override string toString() { result = "argument to Cheetah.Template.Template()" }

  CheetahTemplateInstantiationSink() {
    exists(CallNode call, ClassValue cv |
      cv.getASuperType() = theCheetahTemplateClass() and
      call.getFunction().pointsTo(cv) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
