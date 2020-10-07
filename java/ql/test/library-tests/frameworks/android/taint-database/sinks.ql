import semmle.code.java.security.QueryInjection

from QueryInjectionSink sink
where sink.getLocation().getFile().getBaseName() = "Sinks.java"
select sink
