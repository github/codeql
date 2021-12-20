/** Provides definitions for the `System.ComponentModel` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.ComponentModel.PropertyDescriptorCollection`. */
private class SystemComponentModelPropertyDescriptorCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.ComponentModel.PropertyDescriptor);;Argument[0];Element of Argument[-1];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.ComponentModel.PropertyDescriptor);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.ComponentModel.PropertyDescriptor);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.Object);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.Object);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;Find;(System.String,System.Boolean);;Element of Argument[-1];ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.IEnumerator.Current] of ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;Insert;(System.Int32,System.ComponentModel.PropertyDescriptor);;Argument[1];Element of Argument[-1];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;PropertyDescriptorCollection;(System.ComponentModel.PropertyDescriptor[]);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;PropertyDescriptorCollection;(System.ComponentModel.PropertyDescriptor[]);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;PropertyDescriptorCollection;(System.ComponentModel.PropertyDescriptor[],System.Boolean);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;PropertyDescriptorCollection;(System.ComponentModel.PropertyDescriptor[],System.Boolean);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.Int32);;Element of Argument[-1];ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.Int32);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.Object);;Element of Argument[-1];ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.String);;Element of Argument[-1];ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.String);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;set_Item;(System.Int32,System.Object);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;set_Item;(System.Int32,System.Object);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;set_Item;(System.Object,System.Object);;Argument[1];Element of Argument[-1];value",
      ]
  }
}

/** Data flow for `System.ComponentModel.EventDescriptorCollection`. */
private class SystemComponentModelEventDescriptorCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.ComponentModel;EventDescriptorCollection;false;Add;(System.ComponentModel.EventDescriptor);;Argument[0];Element of Argument[-1];value",
        "System.ComponentModel;EventDescriptorCollection;false;Find;(System.String,System.Boolean);;Element of Argument[-1];ReturnValue;value",
        "System.ComponentModel;EventDescriptorCollection;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.IEnumerator.Current] of ReturnValue;value",
        "System.ComponentModel;EventDescriptorCollection;false;Insert;(System.Int32,System.ComponentModel.EventDescriptor);;Argument[1];Element of Argument[-1];value",
        "System.ComponentModel;EventDescriptorCollection;false;get_Item;(System.Int32);;Element of Argument[-1];ReturnValue;value",
        "System.ComponentModel;EventDescriptorCollection;false;get_Item;(System.String);;Element of Argument[-1];ReturnValue;value",
      ]
  }
}

/** Data flow for `System.ComponentModel.ListSortDescriptionCollection`. */
private class SystemComponentModelListSortDescriptionCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.ComponentModel;ListSortDescriptionCollection;false;get_Item;(System.Int32);;Element of Argument[-1];ReturnValue;value",
        "System.ComponentModel;ListSortDescriptionCollection;false;set_Item;(System.Int32,System.ComponentModel.ListSortDescription);;Argument[1];Element of Argument[-1];value",
      ]
  }
}

/** Data flow for `System.ComponentModel.ComponentCollection`. */
private class SystemComponentModelComponentCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.ComponentModel;ComponentCollection;false;CopyTo;(System.ComponentModel.IComponent[],System.Int32);;Element of Argument[-1];Element of Argument[0];value"
  }
}

/** Data flow for `System.ComponentModel.AttributeCollection`. */
private class SystemComponentModelAttributeCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.ComponentModel;AttributeCollection;false;GetEnumerator;();;Element of Argument[-1];Property[System.Collections.IEnumerator.Current] of ReturnValue;value"
  }
}

/** Data flow for `System.ComponentModel.IBindingList`. */
private class SystemComponentModelIBindingListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.ComponentModel;IBindingList;true;Find;(System.ComponentModel.PropertyDescriptor,System.Object);;Element of Argument[-1];ReturnValue;value"
  }
}
