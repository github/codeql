/** Provides classes and predicates to reason about deep links in Android. */

import java
private import semmle.code.java.frameworks.android.Intent
private import semmle.code.java.frameworks.android.Android
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.xml.AndroidManifest

// ! Experimentation file
// /**
//  * A value-preserving step from the Intent argument of a method call that starts a component to
//  * a `getIntent` call or `Intent` parameter in the component that the Intent pointed to in its constructor.
//  */
// // ! experimental - make a DeepLink step that combine Activity, Service, Receiver, etc.
// private class DeepLinkIntentStep extends AdditionalValueStep {
//   // DeepLinkIntentStep() {
//   //   this instanceof StartActivityIntentStep or
//   //   this instanceof SendBroadcastReceiverIntentStep or
//   //   this instanceof StartServiceIntentStep
//   // }
//   override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
//     // ! simplify below
//     (
//       exists(StartServiceIntentStep startServiceIntentStep | startServiceIntentStep.step(n1, n2))
//       or
//       exists(SendBroadcastReceiverIntentStep sendBroadcastIntentStep |
//         sendBroadcastIntentStep.step(n1, n2)
//       )
//       or
//       exists(StartActivityIntentStep startActivityIntentStep | startActivityIntentStep.step(n1, n2))
//     ) and
//     exists(AndroidComponent andComp |
//       andComp.getAndroidComponentXmlElement().(AndroidActivityXmlElement).hasDeepLink() and
//       n1.asExpr().getFile() = andComp.getFile() // ! see if better way to do this
//     )
//   }
// }
// ! experimental modelling of `parseUri`
/**
 * The method `Intent.parseUri`
 */
class AndroidParseUriMethod extends Method {
  AndroidParseUriMethod() {
    // ! Note: getIntent for older versions before deprecation to parseUri
    (this.hasName("parseUri") or this.hasName("getIntent")) and
    this.getDeclaringType() instanceof TypeIntent
  }
}
