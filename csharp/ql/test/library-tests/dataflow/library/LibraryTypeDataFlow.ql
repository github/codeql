import semmle.code.csharp.dataflow.LibraryTypeDataFlow

predicate callableFlow(string callable, string flow, boolean preservesValue) {
  exists(LibraryTypeDataFlow x, CallableFlowSource source, CallableFlowSink sink, Callable c |
    c.(Modifiable).isPublic() and
    c.getDeclaringType().isPublic() and
    x.callableFlow(source, sink, c, preservesValue) and
    callable = c.getQualifiedNameWithTypes() and
    flow = source.toString() + " -> " + sink.toString()
  )
}

from string entity, string flow, boolean preservesValue
where
  callableFlow(entity, flow, preservesValue) and
  /*
   * Remove certain results to make the test output consistent
   * between different versions of .NET Core.
   */

  not entity = "System.IO.FileStream.CopyToAsync(Stream, int, CancellationToken)"
select entity, flow, preservesValue
