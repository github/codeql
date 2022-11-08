import cpp
import DataFlow::PathGraph
import semmle.code.cpp.dataflow.TaintTracking

abstract class BCryptOpenAlgorithmProviderSink extends DataFlow::Node {}
abstract class BCryptOpenAlgorithmProviderSource extends DataFlow::Node {}

