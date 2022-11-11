import java
private import semmle.code.java.frameworks.android.Android
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dataflow.internal.BaseSSA as BaseSsa

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
 * The method `Context.startActivity` or `startActivities`.
 *
 * DEPRECATED: Use `StartActivityMethod` instead.
 */
deprecated class ContextStartActivityMethod extends Method {
  ContextStartActivityMethod() {
    (this.hasName("startActivity") or this.hasName("startActivities")) and
    this.getDeclaringType() instanceof TypeContext
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
  TaintInheritingContent {
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
    exists(MethodAccess ma, Method m |
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
private class StartComponentMethodAccess extends MethodAccess {
  StartComponentMethodAccess() {
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
 * Holds if `src` reaches the intent argument `arg` of `StartComponentMethodAccess`
 * through intra-procedural steps.
 */
private predicate reaches(Expr src, Argument arg) {
  any(StartComponentMethodAccess ma).getIntentArg() = arg and
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
    exists(StartComponentMethodAccess startActivity, MethodAccess getIntent |
      startActivity.getMethod().overrides*(any(StartActivityMethod m)) and
      getIntent.getMethod().overrides*(any(AndroidGetIntentMethod m)) and
      startActivity.targetsComponentType(getIntent.getReceiverType()) and
      n1.asExpr() = startActivity.getIntentArg() and
      n2.asExpr() = getIntent
    )
  }
}

/**
 * Holds if `targetType` is targeted by an existing `StartComponentMethodAccess` call
 * and it's identified by `id`.
 */
private predicate isTargetableType(AndroidComponent targetType, string id) {
  exists(StartComponentMethodAccess ma | ma.targetsComponentType(targetType)) and
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

  override StartComponentMethodAccess getACall() {
    result.getMethod().hasName("startActivities") and
    result.targetsComponentType(targetType)
  }

  override predicate propagatesFlow(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    exists(ActivityIntentSyntheticGlobal glob | glob.getTargetType() = targetType |
      input = SummaryComponentStack::arrayElementOf(SummaryComponentStack::argument(0)) and
      output = SummaryComponentStack::singleton(SummaryComponent::syntheticGlobal(glob)) and
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

  override predicate propagatesFlow(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    exists(ActivityIntentSyntheticGlobal glob | glob.getTargetType() = targetType |
      input = SummaryComponentStack::singleton(SummaryComponent::syntheticGlobal(glob)) and
      output = SummaryComponentStack::return() and
      preservesValue = true
    )
  }
}

private class ActivityIntentSyntheticGlobal extends SummaryComponent::SyntheticGlobal {
  AndroidComponent targetType;

  ActivityIntentSyntheticGlobal() {
    exists(string id |
      this = "ActivityIntentSyntheticGlobal+" + id and
      isTargetableType(targetType, id)
    )
  }

  AndroidComponent getTargetType() { result = targetType }
}

private class RequiredComponentStackForStartActivities extends RequiredSummaryComponentStack {
  override predicate required(SummaryComponent head, SummaryComponentStack tail) {
    head = SummaryComponent::arrayElement() and
    tail = SummaryComponentStack::argument(0)
  }
}

/**
 * A value-preserving step from the intent argument of a `sendBroadcast` call to
 * the intent parameter in the `onReceive` method of the receiver the
 * intent targeted in its constructor.
 */
private class SendBroadcastReceiverIntentStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(StartComponentMethodAccess sendBroadcast, Method onReceive |
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
    exists(StartComponentMethodAccess startService, Method serviceIntent |
      startService.getMethod().overrides*(any(StartServiceMethod m)) and
      serviceIntent.overrides*(any(AndroidServiceIntentMethod m)) and
      startService.targetsComponentType(serviceIntent.getDeclaringType()) and
      n1.asExpr() = startService.getIntentArg() and
      n2.asParameter() = serviceIntent.getParameter(0)
    )
  }
}

private class IntentBundleFlowSteps extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"namespace;type;subtypes;name;signature;ext;input;output;kind"
        "android.os;BaseBundle;true;get;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;BaseBundle;true;getString;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;BaseBundle;true;getString;(String,String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;BaseBundle;true;getString;(String,String);;Argument[1];ReturnValue;value;manual",
        "android.os;BaseBundle;true;getStringArray;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;BaseBundle;true;keySet;();;Argument[-1].MapKey;ReturnValue.Element;value;manual",
        "android.os;BaseBundle;true;putAll;(PersistableBundle);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
        "android.os;BaseBundle;true;putAll;(PersistableBundle);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
        "android.os;BaseBundle;true;putBoolean;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;BaseBundle;true;putBooleanArray;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;BaseBundle;true;putDouble;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;BaseBundle;true;putDoubleArray;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;BaseBundle;true;putInt;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;BaseBundle;true;putIntArray;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;BaseBundle;true;putLong;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;BaseBundle;true;putLongArray;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;BaseBundle;true;putString;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;BaseBundle;true;putString;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;BaseBundle;true;putStringArray;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;BaseBundle;true;putStringArray;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;false;Bundle;(Bundle);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
        "android.os;Bundle;false;Bundle;(Bundle);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
        "android.os;Bundle;false;Bundle;(PersistableBundle);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
        "android.os;Bundle;false;Bundle;(PersistableBundle);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;clone;();;Argument[-1].MapKey;ReturnValue.MapKey;value;manual",
        "android.os;Bundle;true;clone;();;Argument[-1].MapValue;ReturnValue.MapValue;value;manual",
        // model for Bundle.deepCopy is not fully precise, as some map values aren't copied by value
        "android.os;Bundle;true;deepCopy;();;Argument[-1].MapKey;ReturnValue.MapKey;value;manual",
        "android.os;Bundle;true;deepCopy;();;Argument[-1].MapValue;ReturnValue.MapValue;value;manual",
        "android.os;Bundle;true;getBinder;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getBundle;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getByteArray;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getCharArray;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getCharSequence;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getCharSequence;(String,CharSequence);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getCharSequence;(String,CharSequence);;Argument[1];ReturnValue;value;manual",
        "android.os;Bundle;true;getCharSequenceArray;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getCharSequenceArrayList;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getParcelable;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getParcelableArray;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getParcelableArrayList;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getSerializable;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getSparseParcelableArray;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;getStringArrayList;(String);;Argument[-1].MapValue;ReturnValue;value;manual",
        "android.os;Bundle;true;putAll;(Bundle);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putAll;(Bundle);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putBinder;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putBinder;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putBundle;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putBundle;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putByte;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putByteArray;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putByteArray;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putChar;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putCharArray;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putCharArray;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putCharSequence;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putCharSequence;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putCharSequenceArray;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putCharSequenceArray;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putCharSequenceArrayList;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putCharSequenceArrayList;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putFloat;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putFloatArray;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putIntegerArrayList;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putParcelable;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putParcelable;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putParcelableArray;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putParcelableArray;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putParcelableArrayList;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putParcelableArrayList;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putSerializable;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putSerializable;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putShort;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putShortArray;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putSize;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putSizeF;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putSparseParcelableArray;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putSparseParcelableArray;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;putStringArrayList;;;Argument[0];Argument[-1].MapKey;value;manual",
        "android.os;Bundle;true;putStringArrayList;;;Argument[1];Argument[-1].MapValue;value;manual",
        "android.os;Bundle;true;readFromParcel;;;Argument[0];Argument[-1].MapKey;taint;manual",
        "android.os;Bundle;true;readFromParcel;;;Argument[0];Argument[-1].MapValue;taint;manual",
        // currently only the Extras part of the intent and the data field are fully modeled
        "android.content;Intent;false;Intent;(Intent);;Argument[0].SyntheticField[android.content.Intent.extras].MapKey;Argument[-1].SyntheticField[android.content.Intent.extras].MapKey;value;manual",
        "android.content;Intent;false;Intent;(Intent);;Argument[0].SyntheticField[android.content.Intent.extras].MapValue;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;value;manual",
        "android.content;Intent;false;Intent;(String,Uri);;Argument[1];Argument[-1].SyntheticField[android.content.Intent.data];value;manual",
        "android.content;Intent;false;Intent;(String,Uri,Context,Class);;Argument[1];Argument[-1].SyntheticField[android.content.Intent.data];value;manual",
        "android.content;Intent;true;addCategory;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;addFlags;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;false;createChooser;;;Argument[0..2];ReturnValue.SyntheticField[android.content.Intent.extras].MapValue;value;manual",
        "android.content;Intent;true;getBundleExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;true;getByteArrayExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;true;getCharArrayExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;true;getCharSequenceArrayExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;true;getCharSequenceArrayListExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;true;getCharSequenceExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;true;getData;;;Argument[-1].SyntheticField[android.content.Intent.data];ReturnValue;value;manual",
        "android.content;Intent;true;getDataString;;;Argument[-1].SyntheticField[android.content.Intent.data];ReturnValue;taint;manual",
        "android.content;Intent;true;getExtras;();;Argument[-1].SyntheticField[android.content.Intent.extras];ReturnValue;value;manual",
        "android.content;Intent;false;getIntent;;;Argument[0];ReturnValue.SyntheticField[android.content.Intent.data];taint;manual",
        "android.content;Intent;false;getIntentOld;;;Argument[0];ReturnValue.SyntheticField[android.content.Intent.data];taint;manual",
        "android.content;Intent;true;getParcelableArrayExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;true;getParcelableArrayListExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;true;getParcelableExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;true;getSerializableExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;true;getStringArrayExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;true;getStringArrayListExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;true;getStringExtra;(String);;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;ReturnValue;value;manual",
        "android.content;Intent;false;parseUri;;;Argument[0];ReturnValue.SyntheticField[android.content.Intent.data];taint;manual",
        "android.content;Intent;true;putCharSequenceArrayListExtra;;;Argument[0];Argument[-1].SyntheticField[android.content.Intent.extras].MapKey;value;manual",
        "android.content;Intent;true;putCharSequenceArrayListExtra;;;Argument[1];Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;value;manual",
        "android.content;Intent;true;putCharSequenceArrayListExtra;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;putExtra;;;Argument[0];Argument[-1].SyntheticField[android.content.Intent.extras].MapKey;value;manual",
        "android.content;Intent;true;putExtra;;;Argument[1];Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;value;manual",
        "android.content;Intent;true;putExtra;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;putExtras;(Bundle);;Argument[0].MapKey;Argument[-1].SyntheticField[android.content.Intent.extras].MapKey;value;manual",
        "android.content;Intent;true;putExtras;(Bundle);;Argument[0].MapValue;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;value;manual",
        "android.content;Intent;true;putExtras;(Bundle);;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;putExtras;(Intent);;Argument[0].SyntheticField[android.content.Intent.extras].MapKey;Argument[-1].SyntheticField[android.content.Intent.extras].MapKey;value;manual",
        "android.content;Intent;true;putExtras;(Intent);;Argument[0].SyntheticField[android.content.Intent.extras].MapValue;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;value;manual",
        "android.content;Intent;true;putExtras;(Intent);;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;putIntegerArrayListExtra;;;Argument[0];Argument[-1].SyntheticField[android.content.Intent.extras].MapKey;value;manual",
        "android.content;Intent;true;putIntegerArrayListExtra;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;putParcelableArrayListExtra;;;Argument[0];Argument[-1].SyntheticField[android.content.Intent.extras].MapKey;value;manual",
        "android.content;Intent;true;putParcelableArrayListExtra;;;Argument[1];Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;value;manual",
        "android.content;Intent;true;putParcelableArrayListExtra;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;putStringArrayListExtra;;;Argument[0];Argument[-1].SyntheticField[android.content.Intent.extras].MapKey;value;manual",
        "android.content;Intent;true;putStringArrayListExtra;;;Argument[1];Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;value;manual",
        "android.content;Intent;true;putStringArrayListExtra;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;replaceExtras;(Bundle);;Argument[0].MapKey;Argument[-1].SyntheticField[android.content.Intent.extras].MapKey;value;manual",
        "android.content;Intent;true;replaceExtras;(Bundle);;Argument[0].MapValue;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;value;manual",
        "android.content;Intent;true;replaceExtras;(Bundle);;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;replaceExtras;(Intent);;Argument[0].SyntheticField[android.content.Intent.extras].MapKey;Argument[-1].SyntheticField[android.content.Intent.extras].MapKey;value;manual",
        "android.content;Intent;true;replaceExtras;(Intent);;Argument[0].SyntheticField[android.content.Intent.extras].MapValue;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;value;manual",
        "android.content;Intent;true;replaceExtras;(Intent);;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setAction;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setClass;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setClassName;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setComponent;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setData;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setData;;;Argument[0];Argument[-1].SyntheticField[android.content.Intent.data];value;manual",
        "android.content;Intent;true;setDataAndNormalize;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setDataAndNormalize;;;Argument[0];Argument[-1].SyntheticField[android.content.Intent.data];value;manual",
        "android.content;Intent;true;setDataAndType;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setDataAndType;;;Argument[0];Argument[-1].SyntheticField[android.content.Intent.data];value;manual",
        "android.content;Intent;true;setDataAndTypeAndNormalize;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setDataAndTypeAndNormalize;;;Argument[0];Argument[-1].SyntheticField[android.content.Intent.data];value;manual",
        "android.content;Intent;true;setFlags;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setIdentifier;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setPackage;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setType;;;Argument[-1];ReturnValue;value;manual",
        "android.content;Intent;true;setTypeAndNormalize;;;Argument[-1];ReturnValue;value;manual"
      ]
  }
}

private class IntentComponentTaintSteps extends SummaryModelCsv {
  override predicate row(string s) {
    s =
      [
        "android.content;Intent;true;Intent;(Intent);;Argument[0];Argument[-1];taint;manual",
        "android.content;Intent;true;Intent;(Context,Class);;Argument[1];Argument[-1];taint;manual",
        "android.content;Intent;true;Intent;(String,Uri,Context,Class);;Argument[3];Argument[-1];taint;manual",
        "android.content;Intent;true;getIntent;(String);;Argument[0];ReturnValue;taint;manual",
        "android.content;Intent;true;getIntentOld;(String);;Argument[0];ReturnValue;taint;manual",
        "android.content;Intent;true;parseUri;(String,int);;Argument[0];ReturnValue;taint;manual",
        "android.content;Intent;true;setPackage;;;Argument[0];Argument[-1];taint;manual",
        "android.content;Intent;true;setClass;;;Argument[1];Argument[-1];taint;manual",
        "android.content;Intent;true;setClassName;(Context,String);;Argument[1];Argument[-1];taint;manual",
        "android.content;Intent;true;setClassName;(String,String);;Argument[0..1];Argument[-1];taint;manual",
        "android.content;Intent;true;setComponent;;;Argument[0];Argument[-1];taint;manual",
        "android.content;ComponentName;false;ComponentName;(String,String);;Argument[0..1];Argument[-1];taint;manual",
        "android.content;ComponentName;false;ComponentName;(Context,String);;Argument[1];Argument[-1];taint;manual",
        "android.content;ComponentName;false;ComponentName;(Context,Class);;Argument[1];Argument[-1];taint;manual",
        "android.content;ComponentName;false;ComponentName;(Parcel);;Argument[0];Argument[-1];taint;manual",
        "android.content;ComponentName;false;createRelative;(String,String);;Argument[0..1];ReturnValue;taint;manual",
        "android.content;ComponentName;false;createRelative;(Context,String);;Argument[1];ReturnValue;taint;manual",
        "android.content;ComponentName;false;flattenToShortString;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ComponentName;false;flattenToString;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ComponentName;false;getClassName;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ComponentName;false;getPackageName;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ComponentName;false;getShortClassName;;;Argument[-1];ReturnValue;taint;manual",
        "android.content;ComponentName;false;unflattenFromString;;;Argument[0];ReturnValue;taint;manual"
      ]
  }
}
