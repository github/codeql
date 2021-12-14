/** Provides classes to reason about System Information Leak vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.security.XSS

/** CSV sink models representing methods not susceptible to XSS but outputing to an HTTP response body. */
private class DefaultInformationLeakSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      "javax.servlet.http;HttpServletResponse;false;sendError;(int,String);;Argument[1];information-leak"
  }
}

/** A sink that represent a method that outputs data to an HTTP response. */
abstract class InformationLeakSink extends DataFlow::Node { }

/** A default sink representing methods outputing data to an HTTP response. */
private class DefaultInformationLeakSink extends InformationLeakSink {
  DefaultInformationLeakSink() {
    sinkNode(this, "information-leak") or
    this instanceof XssSink
  }
}
