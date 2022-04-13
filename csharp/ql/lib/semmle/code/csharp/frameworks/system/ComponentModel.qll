/** Provides definitions for the `System.ComponentModel` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.ComponentModel.PropertyDescriptorCollection`. */
private class SystemComponentModelPropertyDescriptorCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.ComponentModel.PropertyDescriptor);;Argument[0];Argument[Qualifier].Element;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.ComponentModel.PropertyDescriptor);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.ComponentModel.PropertyDescriptor);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.Object);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.Object);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;Find;(System.String,System.Boolean);;Argument[Qualifier].Element;ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Collections.IEnumerator.Current];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;Insert;(System.Int32,System.ComponentModel.PropertyDescriptor);;Argument[1];Argument[Qualifier].Element;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;PropertyDescriptorCollection;(System.ComponentModel.PropertyDescriptor[]);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;PropertyDescriptorCollection;(System.ComponentModel.PropertyDescriptor[]);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;PropertyDescriptorCollection;(System.ComponentModel.PropertyDescriptor[],System.Boolean);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;PropertyDescriptorCollection;(System.ComponentModel.PropertyDescriptor[],System.Boolean);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.Object);;Argument[Qualifier].Element;ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.String);;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value",
        "System.ComponentModel;PropertyDescriptorCollection;false;set_Item;(System.Int32,System.Object);;Argument[0];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;set_Item;(System.Int32,System.Object);;Argument[1];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.ComponentModel;PropertyDescriptorCollection;false;set_Item;(System.Object,System.Object);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.ComponentModel.EventDescriptorCollection`. */
private class SystemComponentModelEventDescriptorCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.ComponentModel;EventDescriptorCollection;false;Add;(System.ComponentModel.EventDescriptor);;Argument[0];Argument[Qualifier].Element;value",
        "System.ComponentModel;EventDescriptorCollection;false;Find;(System.String,System.Boolean);;Argument[Qualifier].Element;ReturnValue;value",
        "System.ComponentModel;EventDescriptorCollection;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Collections.IEnumerator.Current];value",
        "System.ComponentModel;EventDescriptorCollection;false;Insert;(System.Int32,System.ComponentModel.EventDescriptor);;Argument[1];Argument[Qualifier].Element;value",
        "System.ComponentModel;EventDescriptorCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.ComponentModel;EventDescriptorCollection;false;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
      ]
  }
}

/** Data flow for `System.ComponentModel.ListSortDescriptionCollection`. */
private class SystemComponentModelListSortDescriptionCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.ComponentModel;ListSortDescriptionCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.ComponentModel;ListSortDescriptionCollection;false;set_Item;(System.Int32,System.ComponentModel.ListSortDescription);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.ComponentModel.ComponentCollection`. */
private class SystemComponentModelComponentCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.ComponentModel;ComponentCollection;false;CopyTo;(System.ComponentModel.IComponent[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value"
  }
}

/** Data flow for `System.ComponentModel.AttributeCollection`. */
private class SystemComponentModelAttributeCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.ComponentModel;AttributeCollection;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Collections.IEnumerator.Current];value"
  }
}

/** Data flow for `System.ComponentModel.IBindingList`. */
private class SystemComponentModelIBindingListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.ComponentModel;IBindingList;true;Find;(System.ComponentModel.PropertyDescriptor,System.Object);;Argument[Qualifier].Element;ReturnValue;value"
  }
}
