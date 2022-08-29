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

// import java
// import semmle.code.xml.AndroidManifest
// import semmle.code.java.frameworks.android.Android
// import semmle.code.java.frameworks.android.Intent
// import semmle.code.java.frameworks.android.AsyncTask
// import semmle.code.java.frameworks.android.DeepLink
// import semmle.code.java.dataflow.DataFlow
// import semmle.code.java.dataflow.TaintTracking
// import semmle.code.java.dataflow.FlowSources
// import semmle.code.java.dataflow.FlowSteps
// import semmle.code.java.dataflow.ExternalFlow
//* select getData() method access in RouterActivity
// from AndroidComponent andComp, MethodAccess ma
// where
//   andComp
//       .getAndroidComponentXmlElement()
//       .getAnIntentFilterElement()
//       .getAnActionElement()
//       .getActionName() = "android.intent.action.VIEW" and
//   andComp
//       .getAndroidComponentXmlElement()
//       .getAnIntentFilterElement()
//       .getACategoryElement()
//       .getCategoryName() = "android.intent.category.BROWSABLE" and
//   andComp
//       .getAndroidComponentXmlElement()
//       .getAnIntentFilterElement()
//       .getACategoryElement()
//       .getCategoryName() = "android.intent.category.DEFAULT" and
//   andComp
//       .getAndroidComponentXmlElement()
//       .getAnIntentFilterElement()
//       .getAChild("data")
//       .hasAttribute("scheme") and // make sure to check for 'android' prefix in real query
//   ma.getMethod().hasName("getData") and
//   //ma.getCompilationUnit().toString() = andComp.toString() // string is "RouterActivity"
//   andComp.getFile() = ma.getFile()
// select ma, "getData usage related to deeplink"
// * play with taint/data
// class DeepLinkConfiguration extends TaintTracking::Configuration {
//   DeepLinkConfiguration() { this = "DeepLinkConfiguration" }
//   override predicate isSource(DataFlow::Node source) {
//     exists(MethodAccess ma, AndroidComponent andComp |
//       ma.getMethod().hasName("getData") and
//       andComp
//           .getAndroidComponentXmlElement()
//           .getAnIntentFilterElement()
//           .getAnActionElement()
//           .getActionName() = "android.intent.action.VIEW" and
//       andComp
//           .getAndroidComponentXmlElement()
//           .getAnIntentFilterElement()
//           .getACategoryElement()
//           .getCategoryName() = "android.intent.category.BROWSABLE" and
//       andComp
//           .getAndroidComponentXmlElement()
//           .getAnIntentFilterElement()
//           .getACategoryElement()
//           .getCategoryName() = "android.intent.category.DEFAULT" and
//       andComp
//           .getAndroidComponentXmlElement()
//           .getAnIntentFilterElement()
//           .getAChild("data")
//           .hasAttribute("scheme") and
//       andComp.getFile() = ma.getFile() and
//       source.asExpr() = ma
//     )
//   }
//   override predicate isSink(DataFlow::Node sink) {
//     exists(Variable v | v.hasName("currentUrl") and sink.asExpr() = v.getAnAccess())
//   }
// }
// from DataFlow::Node src, DataFlow::Node sink, DeepLinkConfiguration config
// where config.hasFlow(src, sink)
// select src, "This environment variable constructs a URL $@.", sink, "here"
// * Intent experimentation:
//from
//   AndroidComponent andComp, MethodAccess ma, StartActivityIntentStep startActIntStep,
//   DataFlow::Node n1, DataFlow::Node n2
// where
//   andComp
//       .getAndroidComponentXmlElement()
//       .getAnIntentFilterElement()
//       .getAnActionElement()
//       .getActionName() = "android.intent.action.VIEW" and
//   andComp
//       .getAndroidComponentXmlElement()
//       .getAnIntentFilterElement()
//       .getACategoryElement()
//       .getCategoryName() = "android.intent.category.BROWSABLE" and
//   andComp
//       .getAndroidComponentXmlElement()
//       .getAnIntentFilterElement()
//       .getACategoryElement()
//       .getCategoryName() = "android.intent.category.DEFAULT" and
//   andComp
//       .getAndroidComponentXmlElement()
//       .getAnIntentFilterElement()
//       .getAChild("data")
//       .hasAttribute("scheme") and // make sure to check for 'android' prefix in real query
//   //ma.getMethod().hasName("getData") and
//   //andComp.getFile() = ma.getFile() and
//   //n1.asExpr() = ma and
//   //n1.asExpr() = ma and
//   andComp.getAnAnnotation() = n1.asExpr() and
//   startActIntStep.step(n1, n2)
// select n1, "deeplink"
// * experiment with StartActivityIntentStep
import java
import semmle.code.java.frameworks.android.DeepLink
import semmle.code.java.dataflow.DataFlow

from StartServiceIntentStep startServiceIntStep, DataFlow::Node n1, DataFlow::Node n2
where startServiceIntStep.step(n1, n2)
select n2, "placeholder"
