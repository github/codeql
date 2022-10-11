/** Provides definitions related to the `Microsoft.VisualBasic` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `Microsoft.VisualBasic.Collection`. */
private class MicrosoftVisualBasicCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "Microsoft.VisualBasic;Collection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "Microsoft.VisualBasic;Collection;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.IEnumerator.Current];value;manual",
        "Microsoft.VisualBasic;Collection;false;get_Item;(System.Int32);;Argument[this].Element;ReturnValue;value;manual",
        "Microsoft.VisualBasic;Collection;false;get_Item;(System.Object);;Argument[this].Element;ReturnValue;value;manual",
        "Microsoft.VisualBasic;Collection;false;get_Item;(System.String);;Argument[this].Element;ReturnValue;value;manual",
      ]
  }
}
