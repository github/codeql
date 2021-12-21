/** Provides definitions related to the `System.Dynamic` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Dynamic.ExpandoObject`. */
private class SystemDynamicExpandoObjectFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Dynamic;ExpandoObject;false;Add;(System.Collections.Generic.KeyValuePair<System.String,System.Object>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Dynamic;ExpandoObject;false;Add;(System.Collections.Generic.KeyValuePair<System.String,System.Object>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
      ]
  }
}
