import semmle.code.csharp.dataflow.LibraryTypeDataFlow

query predicate callableFlow(string callable, string flow, boolean preservesValue) {
  exists(LibraryTypeDataFlow x, CallableFlowSource source, CallableFlowSink sink, Callable c |
    c.(Modifiable).isPublic() and
    c.getDeclaringType().isPublic() and
    x.callableFlow(source, sink, c, preservesValue) and
    callable = c.getQualifiedNameWithTypes() and
    flow = source + " -> " + sink and
    // Remove certain results to make the test output consistent
    // between different versions of .NET Core.
    not callable = "System.IO.FileStream.CopyToAsync(Stream, int, CancellationToken)"
  )
}

query predicate callableFlowAccessPath(string callable, string flow) {
  exists(
    LibraryTypeDataFlow x, CallableFlowSource source, AccessPath sourceAp, CallableFlowSink sink,
    AccessPath sinkAp, Callable c
  |
    c.(Modifiable).isPublic() and
    c.getDeclaringType().isPublic() and
    x.callableFlow(source, sourceAp, sink, sinkAp, c) and
    callable = c.getQualifiedNameWithTypes() and
    flow = source + " [" + sourceAp + "] -> " + sink + " [" + sinkAp + "]"
  )
}
