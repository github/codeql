import semmle.code.csharp.security.dataflow.flowsinks.Html

from HtmlSink sink, File f
where
  sink.getLocation().getFile() = f and
  (f.fromSource() or f.getExtension() = "razor")
select sink
