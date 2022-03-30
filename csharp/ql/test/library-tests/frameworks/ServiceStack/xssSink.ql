import semmle.code.csharp.security.dataflow.XSSSinks

from Sink sink
where
  sink.getLocation().getFile().fromSource() and
  not sink.getLocation().getFile().getAbsolutePath().matches("%/resources/stubs/%")
select sink, sink.getExpr()
