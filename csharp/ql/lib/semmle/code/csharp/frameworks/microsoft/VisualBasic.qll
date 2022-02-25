/** Provides definitions related to the `Microsoft.VisualBasic` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `Microsoft.VisualBasic.Collection`. */
private class MicrosoftVisualBasicCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "Microsoft.VisualBasic;Collection;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Collections.IEnumerator.Current];value",
        "Microsoft.VisualBasic;Collection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "Microsoft.VisualBasic;Collection;false;get_Item;(System.Object);;Argument[Qualifier].Element;ReturnValue;value",
        "Microsoft.VisualBasic;Collection;false;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
      ]
  }
}
