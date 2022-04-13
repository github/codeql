/** Provides definitions related to the `System.Dynamic` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Dynamic.ExpandoObject`. */
private class SystemDynamicExpandoObjectFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Dynamic;ExpandoObject;false;Add;(System.Collections.Generic.KeyValuePair<System.String,System.Object>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Dynamic;ExpandoObject;false;Add;(System.Collections.Generic.KeyValuePair<System.String,System.Object>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
      ]
  }
}
