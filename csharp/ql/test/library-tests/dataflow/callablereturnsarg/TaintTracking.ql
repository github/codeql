import csharp
import Common

class TaintTrackingConfiguration extends TaintTracking::Configuration {
  Configuration c;

  TaintTrackingConfiguration() { this = "Taint " + c }

  override predicate isSource(DataFlow::Node source) { c.isSource(source) }

  override predicate isSink(DataFlow::Node sink) { c.isSink(sink) }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) { c.isBarrierGuard(guard) }
}

from TaintTrackingConfiguration c, Parameter p, int outRefArg
where
  flowOutFromParameter(c, p) and outRefArg = -1
  or
  flowOutFromParameterOutOrRef(c, p, outRefArg)
select p.getCallable(), p.getPosition(), outRefArg
