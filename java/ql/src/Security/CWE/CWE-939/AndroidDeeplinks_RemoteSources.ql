/**
 * @name Android deep links
 * @description Android deep links
 * @problem.severity recommendation
 * @security-severity 0.1
 * @id java/android/deeplinks
 * @tags security
 *       external/cwe/cwe-939
 * @precision high
 */

// * experiment with StartActivityIntentStep
// import java
// import semmle.code.java.frameworks.android.DeepLink
// import semmle.code.java.dataflow.DataFlow
// from StartServiceIntentStep startServiceIntStep, DataFlow::Node n1, DataFlow::Node n2
// where startServiceIntStep.step(n1, n2)
// select n2, "placeholder"
// * experiment with taint-tracking
import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.android.DeepLink
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.frameworks.android.Android
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSteps
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.xml.AndroidManifest
import semmle.code.java.dataflow.TaintTracking

class MyTaintTrackingConfiguration extends TaintTracking::Configuration {
  MyTaintTrackingConfiguration() { this = "MyTaintTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    // exists(AndroidActivityXmlElement andActXmlElem |
    //   andActXmlElem.hasDeepLink() and
    //   source.asExpr() instanceof TypeActivity
    //   )
    source instanceof RemoteFlowSource and //AndroidIntentInput
    exists(AndroidComponent andComp |
      andComp.getAndroidComponentXmlElement().(AndroidActivityXmlElement).hasDeepLink() and
      source.asExpr().getFile() = andComp.getFile() // ! ugly, see if better way to do this
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess m |
      m.getMethod().hasName("getIntent") and
      sink.asExpr() = m
    )
  }
}

from DataFlow::Node src, DataFlow::Node sink, MyTaintTrackingConfiguration config
where config.hasFlow(src, sink)
select src, "This environment variable constructs a URL $@.", sink, "here"
