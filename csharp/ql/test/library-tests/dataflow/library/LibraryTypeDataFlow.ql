import csharp
import semmle.code.csharp.dataflow.LibraryTypeDataFlow

query predicate callableFlow(string callable, string flow, boolean preservesValue) {
  exists(LibraryTypeDataFlow x, CallableFlowSource source, CallableFlowSink sink, Callable c |
    c.(Modifiable).isPublic() and
    c.getDeclaringType().isPublic() and
    callable = c.getQualifiedNameWithTypes() and
    flow = source + " -> " + sink and
    // Remove certain results to make the test output consistent
    // between different versions of .NET Core.
    not callable = "System.IO.FileStream.CopyToAsync(Stream, int, CancellationToken)"
  |
    x.callableFlow(source, sink, c, preservesValue)
    or
    x.callableFlow(source, AccessPath::empty(), sink, AccessPath::empty(), c, preservesValue)
  )
}

query predicate callableFlowAccessPath(string callable, string flow, boolean preservesValue) {
  exists(
    LibraryTypeDataFlow x, CallableFlowSource source, AccessPath sourceAp, CallableFlowSink sink,
    AccessPath sinkAp, Callable c
  |
    c.(Modifiable).isPublic() and
    c.getDeclaringType().isPublic() and
    x.callableFlow(source, sourceAp, sink, sinkAp, c, preservesValue) and
    callable = c.getQualifiedNameWithTypes() and
    flow = source + " [" + sourceAp + "] -> " + sink + " [" + sinkAp + "]"
  |
    sourceAp.length() > 0
    or
    sinkAp.length() > 0
  )
}

query predicate clearsContent(string callable, CallableFlowSource source, string content) {
  exists(LibraryTypeDataFlow x, Callable callable0, DataFlow::Content content0 |
    x.clearsContent(source, content0, callable0) and
    callable = callable0.getQualifiedNameWithTypes() and
    content = content0.toString()
  )
}
