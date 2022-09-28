/** Provides definitions for the `System.ComponentModel` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.ComponentModel.PropertyDescriptorCollection`. */
private class SystemComponentModelPropertyDescriptorCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.ComponentModel.PropertyDescriptor);;Argument[0];Argument[this].Element;value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.ComponentModel.PropertyDescriptor);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.ComponentModel.PropertyDescriptor);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.Object);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;Add;(System.Object);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;Find;(System.String,System.Boolean);;Argument[this].Element;ReturnValue;value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.IEnumerator.Current];value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;Insert;(System.Int32,System.ComponentModel.PropertyDescriptor);;Argument[1];Argument[this].Element;value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;PropertyDescriptorCollection;(System.ComponentModel.PropertyDescriptor[]);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;PropertyDescriptorCollection;(System.ComponentModel.PropertyDescriptor[]);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;PropertyDescriptorCollection;(System.ComponentModel.PropertyDescriptor[],System.Boolean);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;PropertyDescriptorCollection;(System.ComponentModel.PropertyDescriptor[],System.Boolean);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.Int32);;Argument[this].Element;ReturnValue;value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.Int32);;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.Object);;Argument[this].Element;ReturnValue;value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.String);;Argument[this].Element;ReturnValue;value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;get_Item;(System.String);;Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;set_Item;(System.Int32,System.Object);;Argument[0];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;set_Item;(System.Int32,System.Object);;Argument[1];Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value;manual",
        "System.ComponentModel;PropertyDescriptorCollection;false;set_Item;(System.Object,System.Object);;Argument[1];Argument[this].Element;value;manual",
      ]
  }
}

/** Data flow for `System.ComponentModel.EventDescriptorCollection`. */
private class SystemComponentModelEventDescriptorCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.ComponentModel;EventDescriptorCollection;false;Add;(System.ComponentModel.EventDescriptor);;Argument[0];Argument[this].Element;value;manual",
        "System.ComponentModel;EventDescriptorCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.ComponentModel;EventDescriptorCollection;false;Find;(System.String,System.Boolean);;Argument[this].Element;ReturnValue;value;manual",
        "System.ComponentModel;EventDescriptorCollection;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.IEnumerator.Current];value;manual",
        "System.ComponentModel;EventDescriptorCollection;false;Insert;(System.Int32,System.ComponentModel.EventDescriptor);;Argument[1];Argument[this].Element;value;manual",
        "System.ComponentModel;EventDescriptorCollection;false;get_Item;(System.Int32);;Argument[this].Element;ReturnValue;value;manual",
        "System.ComponentModel;EventDescriptorCollection;false;get_Item;(System.String);;Argument[this].Element;ReturnValue;value;manual",
      ]
  }
}

/** Data flow for `System.ComponentModel.ListSortDescriptionCollection`. */
private class SystemComponentModelListSortDescriptionCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.ComponentModel;ListSortDescriptionCollection;false;get_Item;(System.Int32);;Argument[this].Element;ReturnValue;value;manual",
        "System.ComponentModel;ListSortDescriptionCollection;false;set_Item;(System.Int32,System.ComponentModel.ListSortDescription);;Argument[1];Argument[this].Element;value;manual",
      ]
  }
}

/** Data flow for `System.ComponentModel.ComponentCollection`. */
private class SystemComponentModelComponentCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.ComponentModel;ComponentCollection;false;CopyTo;(System.ComponentModel.IComponent[],System.Int32);;Argument[this].Element;Argument[0].Element;value;manual"
  }
}

/** Data flow for `System.ComponentModel.AttributeCollection`. */
private class SystemComponentModelAttributeCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.ComponentModel;AttributeCollection;false;GetEnumerator;();;Argument[this].Element;ReturnValue.Property[System.Collections.IEnumerator.Current];value;manual"
  }
}

/** Data flow for `System.ComponentModel.IBindingList`. */
private class SystemComponentModelIBindingListFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.ComponentModel;IBindingList;true;Find;(System.ComponentModel.PropertyDescriptor,System.Object);;Argument[this].Element;ReturnValue;value;manual"
  }
}
