/** Provides classes and predicates to reason about deep links in Android. */

import java
private import semmle.code.java.frameworks.android.Intent
//private import semmle.code.java.frameworks.android.AsyncTask
private import semmle.code.java.frameworks.android.Android
private import semmle.code.java.dataflow.DataFlow
//private import semmle.code.java.dataflow.DataFlow2
private import semmle.code.java.dataflow.FlowSteps
//private import semmle.code.java.dataflow.FlowSources
//private import semmle.code.java.dataflow.ExternalFlow
//private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.xml.AndroidManifest

// ! if keeping this class, should prbly move to security folder.
// ! Remember to add 'private' annotation as needed to all new classes/predicates below.
// ! and clean-up comments, etc. in below in general...
/**
 * A value-preserving step from the Intent argument of a method call that starts a component to
 * a `getIntent` call or `Intent` parameter in the component that the Intent pointed to in its constructor.
 */
// ! experimental - make a DeepLink step that combine Activity, Service, Receiver, etc.
private class DeepLinkIntentStep extends AdditionalValueStep {
  // DeepLinkIntentStep() {
  //   this instanceof StartActivityIntentStep_ContextAndActivity or
  //   this instanceof SendBroadcastReceiverIntentStep or
  //   this instanceof StartServiceIntentStep
  // }
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    // ! simplify below
    (
      exists(StartServiceIntentStep startServiceIntentStep | startServiceIntentStep.step(n1, n2))
      or
      exists(SendBroadcastReceiverIntentStep sendBroadcastIntentStep |
        sendBroadcastIntentStep.step(n1, n2)
      )
      or
      exists(StartActivityIntentStep startActivityIntentStep | startActivityIntentStep.step(n1, n2))
    ) and
    exists(AndroidComponent andComp |
      andComp.getAndroidComponentXmlElement().(AndroidActivityXmlElement).hasDeepLink() and
      n1.asExpr().getFile() = andComp.getFile() // ! see if better way to do this
    )
  }
}

// // ! experimentation with global flow issue - REMOVE
// /**
//  * A value-preserving step from the Intent variable
//  * the `Intent` Parameter in the `startActivity`.
//  */
// class IntentVariableToStartActivityStep extends AdditionalValueStep {
//   override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
//     exists(
//       MethodAccess startActivity, Variable intentTypeTest, DataFlow2::Node source,
//       DataFlow2::Node sink //ClassInstanceExpr intentTypeTest  |
//     |
//       (
//         startActivity.getMethod().overrides*(any(ContextStartActivityMethod m)) or
//         startActivity.getMethod().overrides*(any(ActivityStartActivityMethod m))
//       ) and
//       intentTypeTest.getType() instanceof TypeIntent and // Variable
//       //intentTypeTest.getConstructedType() instanceof TypeIntent and // ClassInstanceExpr
//       startActivity.getFile().getBaseName() = "MainActivity.java" and // ! REMOVE - for testing only
//       //exists(StartComponentConfiguration cfg | cfg.hasFlow(source, sink)) and // GLOBAL FLOW ATTEMPT
//       DataFlow::localExprFlow(intentTypeTest.getInitializer(), startActivity.getArgument(0)) and // Variable - gives 5 results - misses the 1st ProfileActivity result since no variable with that one
//       //DataFlow::localExprFlow(intentTypeTest, startActivity.getArgument(0)) and // ClassInstanceExpr
//       n1.asExpr() = intentTypeTest.getInitializer() and // Variable
//       //n1.asExpr() = intentTypeTest and // ClassInstanceExpr
//       n2.asExpr() = startActivity.getArgument(0) // ! switch to getStartActivityIntentArg(startActivity)
//     )
//   }
// }
// ! rename?
// ! below works as intended when run by itself (see latest query in AndroidDeeplinks_RemoteSources.ql),
// ! but not when combined with existing flow steps (non-monotonic recursion)
// ! need to figure out how to combine, or wrap all in global flow?
class StartComponentConfiguration extends DataFlow::Configuration {
  StartComponentConfiguration() { this = "StartComponentConfiguration" }

  // Override `isSource` and `isSink`.
  override predicate isSource(DataFlow::Node source) {
    exists(ClassInstanceExpr classInstanceExpr |
      classInstanceExpr.getConstructedType() instanceof TypeIntent and
      source.asExpr() = classInstanceExpr
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess startActivity |
      // ! need to handle for all components, not just Activity
      (
        startActivity.getMethod().overrides*(any(ContextStartActivityMethod m)) or
        startActivity.getMethod().overrides*(any(ActivityStartActivityMethod m))
      ) and
      sink.asExpr() = startActivity.getArgument(0)
    )
  }
  // Optionally override `isBarrier`.
  // Optionally override `isAdditionalFlowStep`.
  //   Then, to query whether there is flow between some `source` and `sink`,
  //  write
  //
  //  ```ql
  //  exists(MyAnalysisConfiguration cfg | cfg.hasFlow(source, sink))
  //  ```
}

/* *********************  INTENT METHODS, E.G. parseUri, getData, getExtras, etc. ********************* */
/*
 * Below is a Draft/Test of modelling `Intent.parseUri`, `Intent.getData`,
 * and `Intent.getExtras` methods
 */

// ! Check if can use pre-existing Synthetic Field.
/**
 * The method `Intent.get%Extra` or `Intent.getExtras`.
 */
class AndroidGetExtrasMethod extends Method {
  AndroidGetExtrasMethod() {
    this.getName().matches("get%Extra%") and
    this.getDeclaringType() instanceof TypeIntent
  }
}

/**
 * The method `Intent.getData`
 */
class AndroidGetDataMethod extends Method {
  AndroidGetDataMethod() {
    this.hasName("getData") and this.getDeclaringType() instanceof TypeIntent
  }
}

/**
 * The method `Intent.parseUri`
 */
class AndroidParseUriMethod extends Method {
  AndroidParseUriMethod() {
    // ! Note to self: getIntent for older versions before deprecation to parseUri
    (this.hasName("parseUri") or this.hasName("getIntent")) and
    this.getDeclaringType() instanceof TypeIntent
  }
}
