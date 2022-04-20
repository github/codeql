/** Provides classes and predicates related to `androidx.slice`. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.ExternalFlow

/** The class `androidx.slice.SliceProvider`. */
class SliceProvider extends Class {
  SliceProvider() { this.hasQualifiedName("androidx.slice", "SliceProvider") }
}

/**
 * An additional value step for modeling the lifecycle of a `SliceProvider`.
 * It connects the `PostUpdateNode` of any update done to the provider object in
 * `onCreateSliceProvider` to the instance parameter of `onBindSlice`.
 */
private class SliceProviderLifecycleStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(Method onCreate, Method onBind, RefType declaringClass |
      declaringClass.getAnAncestor() instanceof SliceProvider and
      onCreate.getDeclaringType() = declaringClass and
      onCreate.hasName("onCreateSliceProvider") and
      onBind.getDeclaringType() = declaringClass and
      onBind.hasName("onBindSlice")
    |
      node1
          .(DataFlow::PostUpdateNode)
          .getPreUpdateNode()
          .(DataFlow::InstanceAccessNode)
          .isOwnInstanceAccess() and
      node1.getEnclosingCallable() = onCreate and
      node2.(DataFlow::InstanceParameterNode).getEnclosingCallable() = onBind
    )
  }
}

private class SliceActionsInheritTaint extends DataFlow::SyntheticFieldContent,
  TaintInheritingContent {
  SliceActionsInheritTaint() { this.getField().matches("androidx.slice.Slice.action") }
}

private class SliceBuildersSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "androidx.slice.builders;ListBuilder;true;addAction;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder;true;addGridRow;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder;true;addInputRange;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder;true;addRange;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder;true;addRating;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder;true;addRow;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder;true;addSelection;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder;true;setHeader;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder;true;setSeeMoreAction;(PendingIntent);;Argument[0];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder;true;setSeeMoreRow;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder;true;build;;;Argument[-1].SyntheticField[androidx.slice.Slice.action];ReturnValue;taint",
        "androidx.slice.builders;ListBuilder$HeaderBuilder;true;setPrimaryAction;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;true;addEndItem;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;true;setInputAction;(PendingIntent);;Argument[0];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;true;setPrimaryAction;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder$RangeBuilder;true;setPrimaryAction;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder$RatingBuilder;true;setInputAction;(PendingIntent);;Argument[0];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder$RatingBuilder;true;setPrimaryAction;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;true;addEndItem;(SliceAction,boolean);;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;true;addEndItem;(SliceAction);;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;true;setPrimaryAction;;;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;true;setTitleItem;(SliceAction,boolean);;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;true;setTitleItem;(SliceAction);;Argument[0].SyntheticField[androidx.slice.Slice.action];Argument[-1].SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;SliceAction;true;create;(PendingIntent,IconCompat,int,CharSequence);;Argument[0];ReturnValue.SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;SliceAction;true;createDeeplink;(PendingIntent,IconCompat,int,CharSequence);;Argument[0];ReturnValue.SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;SliceAction;true;createToggle;(PendingIntent,CharSequence,boolean);;Argument[0];ReturnValue.SyntheticField[androidx.slice.Slice.action];taint",
        "androidx.slice.builders;SliceAction;true;getAction;;;Argument[-1].SyntheticField[androidx.slice.Slice.action];ReturnValue;taint",
        // Fluent models
        "androidx.slice.builders;ListBuilder;true;" +
          [
            "addAction", "addGridRow", "addInputRange", "addRange", "addRating", "addRow",
            "addSelection", "setAccentColor", "setHeader", "setHostExtras", "setIsError",
            "setKeywords", "setLayoutDirection", "setSeeMoreAction", "setSeeMoreRow"
          ] + ";;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$HeaderBuilder;true;" +
          [
            "setContentDescription", "setLayoutDirection", "setPrimaryAction", "setSubtitle",
            "setSummary", "setTitle"
          ] + ";;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;true;" +
          [
            "addEndItem", "setContentDescription", "setInputAction", "setLayoutDirection", "setMax",
            "setMin", "setPrimaryAction", "setSubtitle", "setThumb", "setTitle", "setTitleItem",
            "setValue"
          ] + ";;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RangeBuilder;true;" +
          [
            "setContentDescription", "setMax", "setMode", "setPrimaryAction", "setSubtitle",
            "setTitle", "setTitleItem", "setValue"
          ] + ";;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RatingBuilder;true;" +
          [
            "setContentDescription", "setInputAction", "setMax", "setMin", "setPrimaryAction",
            "setSubtitle", "setTitle", "setTitleItem", "setValue"
          ] + ";;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RowBuilder;true;" +
          [
            "addEndItem", "setContentDescription", "setEndOfSection", "setLayoutDirection",
            "setPrimaryAction", "setSubtitle", "setTitle", "setTitleItem"
          ] + ";;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;SliceAction;true;" +
          ["setChecked", "setContentDescription", "setPriority"] +
          ";;;Argument[-1];ReturnValue;value"
      ]
  }
}

private class SliceProviderSourceModels extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "androidx.slice;SliceProvider;true;onBindSlice;;;Parameter[0];contentprovider",
        "androidx.slice;SliceProvider;true;onCreatePermissionRequest;;;Parameter[0];contentprovider",
        "androidx.slice;SliceProvider;true;onMapIntentToUri;;;Parameter[0];contentprovider",
        "androidx.slice;SliceProvider;true;onSlicePinned;;;Parameter[0];contentprovider",
        "androidx.slice;SliceProvider;true;onSliceUnpinned;;;Parameter[0];contentprovider"
      ]
  }
}
