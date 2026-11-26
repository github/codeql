import semmle.code.csharp.security.dataflow.SqlInjectionQuery

from Sink sink
where
  sink.getLocation().getFile().fromSource() and
  not sink.getLocation().getFile().getAbsolutePath().contains("/resources/stubs/")
select sink, sink.getExpr()
