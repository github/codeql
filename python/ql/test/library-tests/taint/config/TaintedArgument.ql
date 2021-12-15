import python
import semmle.python.dataflow.TaintTracking
import TaintLib
import semmle.python.dataflow.Implementation

from
  TaintTrackingImplementation config, TaintTrackingNode src, CallNode call,
  TaintTrackingContext caller, CallableValue pyfunc, int arg, AttributePath path, TaintKind kind
where
  config instanceof TestConfig and
  config.callWithTaintedArgument(src, call, caller, pyfunc, arg, path, kind)
select config, src, call, caller, pyfunc, arg, path, kind
