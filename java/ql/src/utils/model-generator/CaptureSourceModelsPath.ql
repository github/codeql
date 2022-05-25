/**
 * @name Capture source models.
 * @description Finds APIs that act as sources as they expose already known sources.
 * @kind path-problem
 * @id java/utils/model-generator/source-models-path
 */

private import java
private import semmle.code.java.dataflow.DataFlow
private import internal.CaptureModels
import DataFlow::PathGraph

from TargetApi api, DataFlow::PathNode source, DataFlow::PathNode sink, string kind
where captureSourcePath(api, source, sink, kind)
select sink, source, sink, "$@ flows to here", api, "is a new source."
