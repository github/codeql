/** Provides classes which model the `airspeed` package. */

import python
import semmle.python.web.HttpRequest
import experimental.semmle.python.templates.SSTISink

/** returns the ClassValue representing `airspeed.Template` */
deprecated ClassValue theAirspeedTemplateClass() { result = Value::named("airspeed.Template") }

/**
 * A sink representing the `airspeed.Template` class instantiation argument.
 *
 *  import airspeed
 *  temp = airspeed.Template(`"sink"`)
 */
deprecated class AirspeedTemplateSink extends SSTISink {
  override string toString() { result = "argument to airspeed.Template()" }

  AirspeedTemplateSink() {
    exists(CallNode call |
      call.getFunction().pointsTo(theAirspeedTemplateClass()) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
