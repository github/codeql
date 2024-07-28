import java
private import semmle.code.java.frameworks.android.Android
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dataflow.internal.BaseSSA as BaseSsa
private import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

/** The class `android.content.Intent`. */
class TypeIntent extends Class {
  TypeIntent() { this.hasQualifiedName("android.content", "Intent") }
}

/** The class `android.content.ComponentName`. */
class TypeComponentName extends Class {
  TypeComponentName() { this.hasQualifiedName("android.content", "ComponentName") }
}

/** The class `android.app.Activity`. */
class TypeActivity extends Class {
  TypeActivity() { this.hasQualifiedName("android.app", "Activity") }
}

/** The class `android.app.Service`. */
class TypeService extends Class {
  TypeService() { this.hasQualifiedName("android.app", "Service") }
}

/** The class `android.content.Context`. */
class TypeContext extends RefType {
  // Not inlining this makes it more likely to be used as a sentinel,
  // which is useful when running Android queries on non-Android projects.
  pragma[noinline]
  TypeContext() { this.hasQualifiedName("android.content", "Context") }
}

/** The class `android.content.BroadcastReceiver`. */
class TypeBroadcastReceiver extends Class {
  TypeBroadcastReceiver() { this.hasQualifiedName("android.content", "BroadcastReceiver") }
}

/** The method `Activity.getIntent` */
class AndroidGetIntentMethod extends Method {
  AndroidGetIntentMethod() {
    this.hasName("getIntent") and this.getDeclaringType() instanceof TypeActivity
  }
}

/** The method `BroadcastReceiver.onReceive`. */
class AndroidReceiveIntentMethod extends Method {
  AndroidReceiveIntentMethod() {
    this.hasName("onReceive") and this.getDeclaringType() instanceof TypeBroadcastReceiver
  }
}

/**
 * The method `Service.onStart`, `onStartCommand`,
 * `onBind`, `onRebind`, `onUnbind`, or `onTaskRemoved`.
 */
class AndroidServiceIntentMethod extends Method {
  AndroidServiceIntentMethod() {
    this.hasName(["onStart", "onStartCommand", "onBind", "onRebind", "onUnbind", "onTaskRemoved"]) and
    this.getDeclaringType() instanceof TypeService
  }
}

/**
 * The method `Context.startActivity`, `Context.startActivities`,
 * `Activity.startActivity`,`Activity.startActivities`,
 * `Activity.startActivityForResult`, `Activity.startActivityIfNeeded`,
 * `Activity.startNextMatchingActivity`, `Activity.startActivityFromChild`,
 * or `Activity.startActivityFromFragment`.
 */
class StartActivityMethod extends Method {
  StartActivityMethod() {
    this.getName().matches("start%Activit%") and
    (
      this.getDeclaringType() instanceof TypeContext or
      this.getDeclaringType() instanceof TypeActivity
    )
  }
}

/**
 * The method `Context.sendBroadcast`, `sendBroadcastAsUser`,
 * `sendOrderedBroadcast`, `sendOrderedBroadcastAsUser`,
 * `sendStickyBroadcast`, `sendStickyBroadcastAsUser`,
 * `sendStickyOrderedBroadcast`, `sendStickyOrderedBroadcastAsUser`,
 * or `sendBroadcastWithMultiplePermissions`.
 */
class SendBroadcastMethod extends Method {
  SendBroadcastMethod() {
    this.getName().matches("send%Broadcast%") and
    this.getDeclaringType() instanceof TypeContext
  }
}

/**
 * The method `Context.startService`, `startForegroundService`,
 * `bindIsolatedService`, `bindService`, or `bindServiceAsUser`.
 */
class StartServiceMethod extends Method {
  StartServiceMethod() {
    this.hasName([
        "startService", "startForegroundService", "bindIsolatedService", "bindService",
        "bindServiceAsUser"
      ]) and
    this.getDeclaringType() instanceof TypeContext
  }
}

/** Specifies that if an `Intent` is tainted, then so are its synthetic fields. */
private class IntentFieldsInheritTaint extends DataFlow::SyntheticFieldContent,
  TaintInheritingContent
{
  IntentFieldsInheritTaint() { this.getField().matches("android.content.Intent.%") }
}

/** The method `Intent.getParcelableExtra`. */
class IntentGetParcelableExtraMethod extends Method {
  IntentGetParcelableExtraMethod() {
    this.hasName("getParcelableExtra") and
    this.getDeclaringType() instanceof TypeIntent
  }
}

/** The class `android.os.BaseBundle`, or a class that extends it. */
class AndroidBundle extends Class {
  AndroidBundle() { this.getAnAncestor().hasQualifiedName("android.os", "BaseBundle") }
}

/**
 * An `Intent` that explicitly sets a destination component.
 *
 * The `Intent` is not considered explicit if a `null` value ever flows to the destination
 * component, even if only conditionally.
 *
 * For example, in the following code, `intent` is not considered an `ExplicitIntent`:
 * ```java
 * intent.setClass(condition ? null : "MyClass");
 * ```
 */
class ExplicitIntent extends Expr {
  ExplicitIntent() {
    exists(MethodCall ma, Method m |
      ma.getMethod() = m and
      m.getDeclaringType() instanceof TypeIntent and
      m.hasName(["setPackage", "setClass", "setClassName", "setComponent"]) and
      not exists(NullLiteral nullLiteral | DataFlow::localExprFlow(nullLiteral, ma.getAnArgument())) and
      ma.getQualifier() = this
    )
    or
    exists(ConstructorCall cc, Argument classArg |
      cc.getConstructedType() instanceof TypeIntent and
      cc.getAnArgument() = classArg and
      classArg.getType() instanceof TypeClass and
      not exists(NullLiteral nullLiteral | DataFlow::localExprFlow(nullLiteral, classArg)) and
      cc = this
    )
  }
}

/**
 * A sanitizer for explicit intents.
 *
 * Use this when you want to work only with implicit intents
 * in a `DataFlow` or `TaintTracking` configuration.
 */
class ExplicitIntentSanitizer extends DataFlow::Node {
  ExplicitIntentSanitizer() {
    exists(ExplicitIntent explIntent | DataFlow::localExprFlow(explIntent, this.asExpr()))
  }
}

private class BundleExtrasSyntheticField extends SyntheticField {
  BundleExtrasSyntheticField() { this = "android.content.Intent.extras" }

  override RefType getType() { result instanceof AndroidBundle }
}

/** Holds if extras may be implicitly read from the Intent `node`. */
predicate allowIntentExtrasImplicitRead(DataFlow::Node node, DataFlow::Content c) {
  node.getType() instanceof TypeIntent and
  (
    c instanceof DataFlow::MapValueContent
    or
    c.(DataFlow::SyntheticFieldContent).getType() instanceof AndroidBundle
  )
}

/**
 * The fields to grant URI permissions of the class `android.content.Intent`:
 *
 * - `Intent.FLAG_GRANT_READ_URI_PERMISSION`
 * - `Intent.FLAG_GRANT_WRITE_URI_PERMISSION`
 * - `Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION`
 * - `Intent.FLAG_GRANT_PREFIX_URI_PERMISSION`
 */
class GrantUriPermissionFlag extends Field {
  GrantUriPermissionFlag() {
    this.getDeclaringType() instanceof TypeIntent and
    this.getName().matches("FLAG_GRANT_%_URI_PERMISSION")
  }
}

/** The field `Intent.FLAG_GRANT_READ_URI_PERMISSION`. */
class GrantReadUriPermissionFlag extends GrantUriPermissionFlag {
  GrantReadUriPermissionFlag() { this.hasName("FLAG_GRANT_READ_URI_PERMISSION") }
}

/** The field `Intent.FLAG_GRANT_WRITE_URI_PERMISSION`. */
class GrantWriteUriPermissionFlag extends GrantUriPermissionFlag {
  GrantWriteUriPermissionFlag() { this.hasName("FLAG_GRANT_WRITE_URI_PERMISSION") }
}

/** An instantiation of `android.content.Intent`. */
private class NewIntent extends ClassInstanceExpr {
  NewIntent() { this.getConstructedType() instanceof TypeIntent }

  /** Gets the `Class<?>` argument of this call. */
  Argument getClassArg() {
    result.getType() instanceof TypeClass and
    result = this.getAnArgument()
  }
}

/** A call to a method that starts an Android component. */
private class StartComponentMethodCall extends MethodCall {
  StartComponentMethodCall() {
    this.getMethod().overrides*(any(StartActivityMethod m)) or
    this.getMethod().overrides*(any(StartServiceMethod m)) or
    this.getMethod().overrides*(any(SendBroadcastMethod m))
  }

  /** Gets the intent argument of this call. */
  Argument getIntentArg() {
    (
      result.getType() instanceof TypeIntent or
      result.getType().(Array).getElementType() instanceof TypeIntent
    ) and
    result = this.getAnArgument()
  }

  /** Holds if this targets a component of type `targetType`. */
  predicate targetsComponentType(AndroidComponent targetType) {
    exists(NewIntent newIntent |
      reaches(newIntent, this.getIntentArg()) and
      newIntent.getClassArg().getType().(ParameterizedType).getATypeArgument() = targetType
    )
  }
}

/**
 * Holds if `src` reaches the intent argument `arg` of `StartComponentMethodCall`
 * through intra-procedural steps.
 */
private predicate reaches(Expr src, Argument arg) {
  any(StartComponentMethodCall ma).getIntentArg() = arg and
  src = arg
  or
  exists(Expr mid, BaseSsa::BaseSsaVariable ssa, BaseSsa::BaseSsaUpdate upd |
    reaches(mid, arg) and
    mid = ssa.getAUse() and
    upd = ssa.getAnUltimateLocalDefinition() and
    src = upd.getDefiningExpr().(VariableAssign).getSource()
  )
  or
  exists(CastingExpr e | e.getExpr() = src | reaches(e, arg))
  or
  exists(ChooseExpr e | e.getAResultExpr() = src | reaches(e, arg))
  or
  exists(AssignExpr e | e.getSource() = src | reaches(e, arg))
  or
  exists(ArrayCreationExpr e | e.getInit().getAnInit() = src | reaches(e, arg))
  or
  exists(StmtExpr e | e.getResultExpr() = src | reaches(e, arg))
  or
  exists(NotNullExpr e | e.getExpr() = src | reaches(e, arg))
  or
  exists(WhenExpr e | e.getBranch(_).getAResult() = src | reaches(e, arg))
}

/**
 * A value-preserving step from the intent argument of a `startActivity` call to
 * a `getIntent` call in the activity the intent targeted in its constructor.
 */
private class StartActivityIntentStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(StartComponentMethodCall startActivity, MethodCall getIntent |
      startActivity.getMethod().overrides*(any(StartActivityMethod m)) and
      getIntent.getMethod().overrides*(any(AndroidGetIntentMethod m)) and
      startActivity.targetsComponentType(getIntent.getReceiverType()) and
      n1.asExpr() = startActivity.getIntentArg() and
      n2.asExpr() = getIntent
    )
  }
}

/**
 * Holds if `targetType` is targeted by an existing `StartComponentMethodCall` call
 * and it's identified by `id`.
 */
private predicate isTargetableType(AndroidComponent targetType, string id) {
  exists(StartComponentMethodCall ma | ma.targetsComponentType(targetType)) and
  targetType.getQualifiedName() = id
}

private class StartActivitiesSyntheticCallable extends SyntheticCallable {
  AndroidComponent targetType;

  StartActivitiesSyntheticCallable() {
    exists(string id |
      this = "android.content.Activity.startActivities()+" + id and
      isTargetableType(targetType, id)
    )
  }

  override StartComponentMethodCall getACall() {
    result.getMethod().hasName("startActivities") and
    result.targetsComponentType(targetType)
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    exists(ActivityIntentSyntheticGlobal glob | glob.getTargetType() = targetType |
      input = "Argument[0].ArrayElement" and
      output = "SyntheticGlobal[" + glob + "]" and
      preservesValue = true
    )
  }
}

private class GetIntentSyntheticCallable extends SyntheticCallable {
  AndroidComponent targetType;

  GetIntentSyntheticCallable() {
    exists(string id |
      this = "android.content.Activity.getIntent()+" + id and
      isTargetableType(targetType, id)
    )
  }

  override Call getACall() {
    result.getCallee() instanceof AndroidGetIntentMethod and
    result.getEnclosingCallable().getDeclaringType() = targetType
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    exists(ActivityIntentSyntheticGlobal glob | glob.getTargetType() = targetType |
      input = "SyntheticGlobal[" + glob + "]" and
      output = "ReturnValue" and
      preservesValue = true
    )
  }
}

private class ActivityIntentSyntheticGlobal extends FlowSummaryImpl::Private::SyntheticGlobal {
  AndroidComponent targetType;

  ActivityIntentSyntheticGlobal() {
    exists(string id |
      this = "ActivityIntentSyntheticGlobal+" + id and
      isTargetableType(targetType, id)
    )
  }

  AndroidComponent getTargetType() { result = targetType }
}

/**
 * A value-preserving step from the intent argument of a `sendBroadcast` call to
 * the intent parameter in the `onReceive` method of the receiver the
 * intent targeted in its constructor.
 */
private class SendBroadcastReceiverIntentStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(StartComponentMethodCall sendBroadcast, Method onReceive |
      sendBroadcast.getMethod().overrides*(any(SendBroadcastMethod m)) and
      onReceive.overrides*(any(AndroidReceiveIntentMethod m)) and
      sendBroadcast.targetsComponentType(onReceive.getDeclaringType()) and
      n1.asExpr() = sendBroadcast.getIntentArg() and
      n2.asParameter() = onReceive.getParameter(1)
    )
  }
}

/**
 * A value-preserving step from the intent argument of a `startService` call to
 * the intent parameter in an `AndroidServiceIntentMethod` of the service the
 * intent targeted in its constructor.
 */
private class StartServiceIntentStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(StartComponentMethodCall startService, Method serviceIntent |
      startService.getMethod().overrides*(any(StartServiceMethod m)) and
      serviceIntent.overrides*(any(AndroidServiceIntentMethod m)) and
      startService.targetsComponentType(serviceIntent.getDeclaringType()) and
      n1.asExpr() = startService.getIntentArg() and
      n2.asParameter() = serviceIntent.getParameter(0)
    )
  }
}
