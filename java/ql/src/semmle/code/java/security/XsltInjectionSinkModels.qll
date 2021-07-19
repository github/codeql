/** Provides sink models relating to XSLT injection vulnerabilities. */

import semmle.code.java.dataflow.ExternalFlow

private class DefaultXsltInjectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.xml.transform;Transformer;false;transform;;;Argument[-1];xslt",
        "net.sf.saxon.s9api;XsltTransformer;false;transform;;;Argument[-1];xslt",
        "net.sf.saxon.s9api;Xslt30Transformer;false;transform;;;Argument[-1];xslt",
        "net.sf.saxon.s9api;Xslt30Transformer;false;applyTemplates;;;Argument[-1];xslt",
        "net.sf.saxon.s9api;Xslt30Transformer;false;callFunction;;;Argument[-1];xslt",
        "net.sf.saxon.s9api;Xslt30Transformer;false;callTemplate;;;Argument[-1];xslt"
      ]
  }
}
