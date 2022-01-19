/** Provides definitions related to the `Microsoft.VisualBasic` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `Microsoft.VisualBasic.Collection`. */
private class MicrosoftVisualBasicCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "Microsoft.VisualBasic;Collection;false;GetEnumerator;();;Element of Argument[Qualifier];Property[System.Collections.IEnumerator.Current] of ReturnValue;value",
        "Microsoft.VisualBasic;Collection;false;get_Item;(System.Int32);;Element of Argument[Qualifier];ReturnValue;value",
        "Microsoft.VisualBasic;Collection;false;get_Item;(System.Object);;Element of Argument[Qualifier];ReturnValue;value",
        "Microsoft.VisualBasic;Collection;false;get_Item;(System.String);;Element of Argument[Qualifier];ReturnValue;value",
      ]
  }
}
