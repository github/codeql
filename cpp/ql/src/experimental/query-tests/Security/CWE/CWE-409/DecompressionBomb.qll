import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking

/**
 * The Decompression Sink instances, extend this class to define new decompression sinks.
 */
abstract class DecompressionFunction extends Function {
  abstract int getArchiveParameterIndex();
}

/**
 * The Decompression Flow Steps, extend this class to define new decompression sinks.
 */
abstract class DecompressionFlowStep extends Function {
  abstract predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2);
}
