private import java
private import Jdk.Sinks as JDK

bindingset[sink]
predicate isExcludedSink(string sink) { JDK::isExcludedSink(sink) }
