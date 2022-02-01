/** Provides definitions related to the `System.ComponentModel.Design` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.ComponentModel.Design.DesignerCollectionService`. */
private class SystemComponentModelDesignDesignerCollectionServiceFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.ComponentModel.Design;DesignerOptionService+DesignerOptionCollection;false;get_Item;(System.Int32);;Element of Argument[Qualifier];ReturnValue;value",
        "System.ComponentModel.Design;DesignerOptionService+DesignerOptionCollection;false;get_Item;(System.String);;Element of Argument[Qualifier];ReturnValue;value",
      ]
  }
}

/** Data flow for `System.ComponentModel.Design.DesignerVerbCollection`. */
private class SystemComponentModelDesignDesignerVerbCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.ComponentModel.Design;DesignerVerbCollection;false;Add;(System.ComponentModel.Design.DesignerVerb);;Argument[0];Element of Argument[Qualifier];value",
        "System.ComponentModel.Design;DesignerVerbCollection;false;AddRange;(System.ComponentModel.Design.DesignerVerbCollection);;Element of Argument[0];Element of Argument[Qualifier];value",
        "System.ComponentModel.Design;DesignerVerbCollection;false;AddRange;(System.ComponentModel.Design.DesignerVerb[]);;Element of Argument[0];Element of Argument[Qualifier];value",
        "System.ComponentModel.Design;DesignerVerbCollection;false;CopyTo;(System.ComponentModel.Design.DesignerVerb[],System.Int32);;Element of Argument[Qualifier];Element of Argument[0];value",
        "System.ComponentModel.Design;DesignerVerbCollection;false;Insert;(System.Int32,System.ComponentModel.Design.DesignerVerb);;Argument[1];Element of Argument[Qualifier];value",
        "System.ComponentModel.Design;DesignerVerbCollection;false;get_Item;(System.Int32);;Element of Argument[Qualifier];ReturnValue;value",
        "System.ComponentModel.Design;DesignerVerbCollection;false;set_Item;(System.Int32,System.ComponentModel.Design.DesignerVerb);;Argument[1];Element of Argument[Qualifier];value",
      ]
  }
}

/** Data flow for `System.ComponentModel.Design.DesignerCollection`. */
private class SystemComponentModelDesignDesignerCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.ComponentModel.Design;DesignerCollection;false;GetEnumerator;();;Element of Argument[Qualifier];Property[System.Collections.IEnumerator.Current] of ReturnValue;value"
  }
}
