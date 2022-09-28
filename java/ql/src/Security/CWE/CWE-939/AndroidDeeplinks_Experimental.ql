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

// ! REMOVE this file
// * experiment with StartActivityIntentStep
import java
import semmle.code.xml.AndroidManifest

// import semmle.code.java.dataflow.DataFlow
// from StartServiceIntentStep startServiceIntStep, DataFlow::Node n1, DataFlow::Node n2
// where startServiceIntStep.step(n1, n2)
// select n2, "placeholder"
// * experiment with Global Flow
// import java
// import semmle.code.java.dataflow.TaintTracking
// import semmle.code.java.frameworks.android.Intent
// import semmle.code.java.frameworks.android.Android
// import semmle.code.java.dataflow.DataFlow
// import semmle.code.java.dataflow.FlowSteps
// import semmle.code.java.dataflow.FlowSources
// import semmle.code.java.dataflow.ExternalFlow
// import semmle.code.xml.AndroidManifest
// import semmle.code.java.dataflow.TaintTracking
// class StartComponentConfiguration extends DataFlow::Configuration {
//   StartComponentConfiguration() { this = "StartComponentConfiguration" }
//   // Override `isSource` and `isSink`.
//   override predicate isSource(DataFlow::Node source) {
//     exists(ClassInstanceExpr classInstanceExpr |
//       classInstanceExpr.getConstructedType() instanceof TypeIntent and
//       source.asExpr() = classInstanceExpr
//     )
//   }
//   override predicate isSink(DataFlow::Node sink) {
//     exists(MethodAccess startActivity |
//       (
//         startActivity.getMethod().overrides*(any(ContextStartActivityMethod m)) or
//         startActivity.getMethod().overrides*(any(ActivityStartActivityMethod m))
//       ) and
//       sink.asExpr() = startActivity.getArgument(0)
//     )
//   }
// }
// from
//   DataFlow::Node src, DataFlow::Node sink, StartComponentConfiguration config,
// where
//   config.hasFlow(src, sink) and
//   sink.asExpr().getFile().getBaseName() = "MainActivity.java" // ! just for faster testing, remove when done
// select src, "This source flows to this $@.", sink, "sink"
// * simple query as placeholder
from AndroidActivityXmlElement actXmlElement
where
  actXmlElement.hasDeepLink() and
  not actXmlElement.getFile().(AndroidManifestXmlFile).isInBuildDirectory()
select actXmlElement, "A deeplink is used here."
