/** Provides definitions related to the `System.Dynamic` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Dynamic.ExpandoObject`. */
private class SystemDynamicExpandoObjectFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Dynamic;ExpandoObject;false;Add;(System.Collections.Generic.KeyValuePair<System.String,System.Object>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.Dynamic;ExpandoObject;false;Add;(System.Collections.Generic.KeyValuePair<System.String,System.Object>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
      ]
  }
}
