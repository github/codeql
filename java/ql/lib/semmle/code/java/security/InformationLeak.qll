/** Provides classes to reason about System Information Leak vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.security.XSS

/** A sink that represent a method that outputs data to an HTTP response. */
abstract class InformationLeakSink extends DataFlow::Node { }

/** A default sink representing methods outputing data to an HTTP response. */
private class DefaultInformationLeakSink extends InformationLeakSink {
  DefaultInformationLeakSink() {
    sinkNode(this, "information-leak") or
    this instanceof XssSink
  }
}
