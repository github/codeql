/** Provides classes and predicates related to `androidx.slice`. */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class SliceBuildersSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "androidx.slice.builders;ListBuilder;false;addAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addGridRow;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addInputRange;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addRange;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addRating;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addRow;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;addSelection;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;setHeader;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;false;setSeeMoreAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;true;setSeeMoreRow;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;true;build;;;Argument[-1];ReturnValue;taint",
        "androidx.slice.builders;ListBuilder$HeaderBuilder;false;setPrimaryAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;addEndItem;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setInputAction;(PendingIntent);;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;false;setPrimaryAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RangeBuilder;false;setPrimaryAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setInputAction;(PendingIntent);;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RatingBuilder;false;setPrimaryAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;addEndItem;(SliceAction,boolean);;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;addEndItem;(SliceAction);;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setPrimaryAction;;;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setTitleItem;(SliceAction,boolean);;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;false;setTitleItem;(SliceAction);;Argument[0];Argument[-1];taint",
        "androidx.slice.builders;SliceAction;false;create;(PendingIntent,IconCompat,int,CharSequence);;Argument[0];ReturnValue;taint",
        "androidx.slice.builders;SliceAction;false;createDeeplink;(PendingIntent,IconCompat,int,CharSequence);;Argument[0];ReturnValue;taint",
        "androidx.slice.builders;SliceAction;false;createToggle;(PendingIntent,CharSequence,boolean);;Argument[0];ReturnValue;taint",
        "androidx.slice.builders;SliceAction;false;getAction;;;Argument[-1];ReturnValue;taint",
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
