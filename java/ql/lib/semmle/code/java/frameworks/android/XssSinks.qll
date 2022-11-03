/** Provides XSS sink models relating to the `android.webkit.WebView` class. */

import java
private import semmle.code.java.dataflow.ExternalFlow

/** CSV sink models representing methods susceptible to XSS attacks. */
private class DefaultXssSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.webkit;WebView;false;loadData;;;Argument[0];xss",
        "android.webkit;WebView;false;loadDataWithBaseURL;;;Argument[1];xss",
        "android.webkit;WebView;false;evaluateJavascript;;;Argument[0];xss"
      ]
  }
}
