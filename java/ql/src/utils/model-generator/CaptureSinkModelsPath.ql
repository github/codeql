/**
 * @name Capture sink models.
 * @description Finds public methods that act as sinks as they flow into a a known sink.
 * @kind path-problem
 * @id java/utils/model-generator/sink-models-path
 */

private import java
private import semmle.code.java.dataflow.DataFlow
private import internal.CaptureModels
import DataFlow::PathGraph

from TargetApi api, DataFlow::PathNode source, DataFlow::PathNode sink, string kind
where captureSinkPath(api, source, sink, kind)
select sink, source, sink, "$@ flows to here", api, "is a new sink."
