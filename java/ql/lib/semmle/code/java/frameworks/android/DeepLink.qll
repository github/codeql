/** Provides classes and predicates to reason about deep links in Android. */

import java
private import semmle.code.java.frameworks.android.Intent
private import semmle.code.java.frameworks.android.AsyncTask
private import semmle.code.java.frameworks.android.Android
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.ExternalFlow

// ! Remember to add 'private' annotation as needed to all new classes/predicates below.
/* *********  OTHER COMPONENTS (SERVICE, RECEIVER) *********** */
/**
 * The class `android.app.Service`.
 */
class TypeService extends Class {
  TypeService() { this.hasQualifiedName("android.app", "Service") }
}

/**
 * The method `Context.startService` or `Context.startForegroundService`.
 */
class ContextStartServiceMethod extends Method {
  ContextStartServiceMethod() {
    (this.hasName("startService") or this.hasName("startForegroundService")) and
    this.getDeclaringType() instanceof TypeContext
  }
}

/**
 * A method of type Service that receives an Intent as a parameter.
 * Namely: `Service.onStart`, `Service.onStartCommand`,
 * `Service.onBind`, `Service.onRebind`
 * `Service.onUnbind`, or
 * `Service.onTaskRemoved`
 */
class AndroidServeIntentMethod extends Method {
  AndroidServeIntentMethod() {
    (
      this.hasName("onStart") or
      this.hasName("onStartCommand") or
      // this.getName.matches("onStart%") or // could maybe switch with the above
      this.hasName("onBind") or
      this.hasName("onRebind") or
      this.hasName("onUnbind") or
      // this.getName.matches("on%bind") or // could maybe switch with the above
      this.hasName("onTaskRemoved")
    ) and
    this.getDeclaringType() instanceof TypeService
  }
}

/**
 * The method `Service.onStart`, `Service.onStartCommand`,
 * `Service.onBind`, `Service.onRebind`
 * `Service.onUnbind`, or
 * `Service.onTaskRemoved`
 */
class AndroidServeIntentMethod2 extends Method {
  AndroidServeIntentMethod2() {
    (
      this instanceof ServiceOnStartMethod or
      this instanceof ServiceOnBindMethod or
      this instanceof ServiceOnUnbindMethod or
      this instanceof ServiceOnTaskRemovedMethod
    ) and
    this.getDeclaringType() instanceof TypeService
  }
}

/**
 * The method `Service.onStart` or `Service.onStartCommand`.
 */
class ServiceOnStartMethod extends Method {
  ServiceOnStartMethod() {
    (this.hasName("onStart") or this.hasName("onStartCommand")) and
    this.getDeclaringType() instanceof TypeService
  }
}

/**
 * The method `Service.onBind` or `Service.onRebind`.
 */
class ServiceOnBindMethod extends Method {
  ServiceOnBindMethod() {
    (this.hasName("onBind") or this.hasName("onRebind")) and
    this.getDeclaringType() instanceof TypeService
  }
}

/**
 * The method `Service.onUnbind`.
 */
class ServiceOnUnbindMethod extends Method {
  ServiceOnUnbindMethod() {
    this.hasName("onUnbind") and
    this.getDeclaringType() instanceof TypeService
  }
}

/**
 * The method `Service.onTaskRemoved`.
 */
class ServiceOnTaskRemovedMethod extends Method {
  ServiceOnTaskRemovedMethod() {
    this.hasName("onTaskRemoved") and
    this.getDeclaringType() instanceof TypeService
  }
}

// ! update QLDoc more if needed (e.g. remove `onStart` reference)
/**
 * A value-preserving step from the Intent argument of a `startService` call to
 * the `Intent` Parameter in the `onStart` method of the Service the Intent pointed
 * to in its constructor.
 */
class StartServiceIntentStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodAccess startService, Method onStart, ClassInstanceExpr newIntent |
      startService.getMethod().overrides*(any(ContextStartServiceMethod m)) and
      //onStart.overrides*(any(ServiceOnStartMethod m)) and
      //onStart.overrides*(any(AndroidServeIntentMethod m)) and
      onStart.overrides*(any(AndroidServeIntentMethod2 m)) and
      newIntent.getConstructedType() instanceof TypeIntent and
      DataFlow::localExprFlow(newIntent, startService.getArgument(0)) and
      newIntent.getArgument(1).getType().(ParameterizedType).getATypeArgument() =
        onStart.getDeclaringType() and
      n1.asExpr() = startService.getArgument(0) and
      n2.asParameter() = onStart.getParameter(0)
    )
  }
}

// /**
//  * The class `android.content.BroadcastReceiver`.
//  */
// class TypeBroadcastReceiver extends Class {
//     TypeBroadcastReceiver() { this.hasQualifiedName("android.content", "BroadcastReceiver") }
//   }
/**
 * The method `Context.sendBroadcast`.
 */
class ContextSendBroadcastMethod extends Method {
  ContextSendBroadcastMethod() {
    this.getName().matches("send%Broadcast%") and // ! double-check this - seems to work based on quick-eval
    this.getDeclaringType() instanceof TypeContext
  }
}

// ! do I need to model this as well?
/**
 * The method `BroadcastReceiver.peekService`.
 */
class BroadcastReceiverPeekServiceIntentMethod extends Method {
  BroadcastReceiverPeekServiceIntentMethod() {
    this.hasName("peekService") and this.getDeclaringType() instanceof TypeBroadcastReceiver
  }
}

// /**
//  * The method `BroadcastReceiver.onReceive`.
//  */
// class AndroidReceiveIntentMethod extends Method {
//     AndroidReceiveIntentMethod() {
//       this.hasName("onReceive") and this.getDeclaringType() instanceof TypeBroadcastReceiver
//     }
//   }
/**
 * A value-preserving step from the Intent argument of a `sendBroadcast` call to
 * the `Intent` Parameter in the `onStart` method of the BroadcastReceiver the
 * Intent pointed to in its constructor.
 */
class SendBroadcastReceiverIntentStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodAccess sendBroadcast, Method onReceive, ClassInstanceExpr newIntent |
      sendBroadcast.getMethod().overrides*(any(ContextSendBroadcastMethod m)) and
      onReceive.overrides*(any(AndroidReceiveIntentMethod m)) and
      newIntent.getConstructedType() instanceof TypeIntent and
      DataFlow::localExprFlow(newIntent, sendBroadcast.getArgument(0)) and
      newIntent.getArgument(1).getType().(ParameterizedType).getATypeArgument() =
        onReceive.getDeclaringType() and
      n1.asExpr() = sendBroadcast.getArgument(0) and
      n2.asParameter() = onReceive.getParameter(1)
    )
  }
}

/**
 * The method `Activity.startActivity`.
 */
class ActivityStartActivityMethod extends Method {
  ActivityStartActivityMethod() {
    // should capture all `startAct` methods in the Activity class
    // except for `startNextMatchingActivity`, which I'm leaving out for now since seems potentially more complicated
    this.getName().matches("startActivit%") and
    this.getDeclaringType() instanceof TypeActivity
  }
}

/**
 * A value-preserving step from the Intent argument of a `startActivity` call from
 * the Activity classs (not Context like the original StartActivityIntentStep in Intent.qll)
 * to a `getIntent` call in the Activity the Intent pointed to in its constructor.
 */
private class StartActivityIntentStep_ActivityClass extends AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodAccess startActivity, MethodAccess getIntent, ClassInstanceExpr newIntent |
      startActivity.getMethod().overrides*(any(ActivityStartActivityMethod m)) and
      getIntent.getMethod().overrides*(any(AndroidGetIntentMethod m)) and
      newIntent.getConstructedType() instanceof TypeIntent and
      DataFlow::localExprFlow(newIntent, startActivity.getArgument(0)) and // ! startActivityFromChild and startActivityFromFragment have Intent as argument(1)...
      newIntent.getArgument(1).getType().(ParameterizedType).getATypeArgument() =
        getIntent.getReceiverType() and
      n1.asExpr() = startActivity.getArgument(0) and // ! startActivityFromChild and startActivityFromFragment have Intent as argument(1)...
      n2.asExpr() = getIntent
    )
  }
}

/* *********  INTENT METHODS, E.G. parseUri, getData, getExtras, etc. *********** */
// ! Check if can use pre-existing Synthetic Field instead of the below.
/**
 * The method `Intent.get%Extra` or `Intent.getExtras`.
 */
class AndroidGetExtrasMethod extends Method {
  AndroidGetExtrasMethod() {
    (this.hasName("getExtras") or this.getName().matches("get%Extra")) and // ! switch to get%Extra% instead, I think wildcard holds for nothing there
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
    (this.hasName("parseUri") or this.hasName("getIntent")) and // getIntent for older versions before deprecation to parseUri
    this.getDeclaringType() instanceof TypeIntent
  }
}

/**
 * A taint step from the Intent argument of a `startActivity` call to
 * a `Intent.parseUri` call in the Activity the Intent pointed to in its constructor.
 */
private class StartActivityParseUriStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodAccess startActivity, MethodAccess parseUri, ClassInstanceExpr newIntent |
      startActivity.getMethod().overrides*(any(ContextStartActivityMethod m)) and
      parseUri.getMethod().overrides*(any(AndroidParseUriMethod m)) and
      newIntent.getConstructedType() instanceof TypeIntent and
      DataFlow::localExprFlow(newIntent, startActivity.getArgument(0)) and
      newIntent.getArgument(1).getType().(ParameterizedType).getATypeArgument() =
        parseUri.getReceiverType() and
      n1.asExpr() = startActivity.getArgument(0) and
      n2.asExpr() = parseUri
    )
  }
}

/**
 * A taint step from the Intent argument of a `startActivity` call to
 * a `Intent.get%Extra%` call in the Activity the Intent pointed to in its constructor.
 */
private class StartActivityGetDataStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodAccess startActivity, MethodAccess getData, ClassInstanceExpr newIntent |
      startActivity.getMethod().overrides*(any(ContextStartActivityMethod m)) and
      getData.getMethod().overrides*(any(AndroidGetDataMethod m)) and
      newIntent.getConstructedType() instanceof TypeIntent and
      DataFlow::localExprFlow(newIntent, startActivity.getArgument(0)) and
      newIntent.getArgument(1).getType().(ParameterizedType).getATypeArgument() =
        getData.getReceiverType() and
      n1.asExpr() = startActivity.getArgument(0) and
      n2.asExpr() = getData
    )
  }
}

/**
 * A taint step from the Intent argument of a `startActivity` call to
 * a `Intent.getData` call in the Activity the Intent pointed to in its constructor.
 */
private class StartActivityGetExtrasStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodAccess startActivity, MethodAccess getExtras, ClassInstanceExpr newIntent |
      startActivity.getMethod().overrides*(any(ContextStartActivityMethod m)) and
      getExtras.getMethod().overrides*(any(AndroidGetExtrasMethod m)) and
      newIntent.getConstructedType() instanceof TypeIntent and
      DataFlow::localExprFlow(newIntent, startActivity.getArgument(0)) and
      newIntent.getArgument(1).getType().(ParameterizedType).getATypeArgument() =
        getExtras.getReceiverType() and
      n1.asExpr() = startActivity.getArgument(0) and
      n2.asExpr() = getExtras
    )
  }
}
