/**
 * Provides classes and predicates for working with Spring classes and interfaces from
 * `org.springframework.beans`.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

/**
 * Provides models for the `org.springframework.beans` package.
 */
private class FlowSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.springframework.beans;PropertyValue;false;PropertyValue;(String,Object);;Argument[0];Argument[-1].MapKey;value",
        "org.springframework.beans;PropertyValue;false;PropertyValue;(String,Object);;Argument[1];Argument[-1].MapValue;value",
        "org.springframework.beans;PropertyValue;false;PropertyValue;(PropertyValue);;Argument[0];Argument[-1];value",
        "org.springframework.beans;PropertyValue;false;PropertyValue;(PropertyValue,Object);;Argument[0].MapKey;Argument[-1].MapKey;value",
        "org.springframework.beans;PropertyValue;false;PropertyValue;(PropertyValue,Object);;Argument[1];Argument[-1].MapValue;value",
        "org.springframework.beans;PropertyValue;false;getName;;;Argument[-1].MapKey;ReturnValue;value",
        "org.springframework.beans;PropertyValue;false;getValue;;;Argument[-1].MapValue;ReturnValue;value",
        "org.springframework.beans;PropertyValues;true;getPropertyValue;;;Argument[-1].Element;ReturnValue;value",
        "org.springframework.beans;PropertyValues;true;getPropertyValues;;;Argument[-1].Element;ReturnValue.ArrayElement;value",
        "org.springframework.beans;MutablePropertyValues;true;add;(String,Object);;Argument[0];Argument[-1].Element.MapKey;value",
        "org.springframework.beans;MutablePropertyValues;true;add;(String,Object);;Argument[-1];ReturnValue;value",
        "org.springframework.beans;MutablePropertyValues;true;add;(String,Object);;Argument[1];Argument[-1].Element.MapValue;value",
        "org.springframework.beans;MutablePropertyValues;true;addPropertyValue;(PropertyValue);;Argument[0];Argument[-1].Element;value",
        "org.springframework.beans;MutablePropertyValues;true;addPropertyValue;(PropertyValue);;Argument[-1];ReturnValue;value",
        "org.springframework.beans;MutablePropertyValues;true;addPropertyValue;(String,Object);;Argument[0];Argument[-1].Element.MapKey;value",
        "org.springframework.beans;MutablePropertyValues;true;addPropertyValue;(String,Object);;Argument[1];Argument[-1].Element.MapValue;value",
        "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(Map);;Argument[0].MapKey;Argument[-1].Element.MapKey;value",
        "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(Map);;Argument[0].MapValue;Argument[-1].Element.MapValue;value",
        "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(Map);;Argument[-1];ReturnValue;value",
        "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(PropertyValues);;Argument[0].Element;Argument[-1].Element;value",
        "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(PropertyValues);;Argument[-1];ReturnValue;value",
        "org.springframework.beans;MutablePropertyValues;true;get;;;Argument[-1].Element.MapValue;ReturnValue;value",
        "org.springframework.beans;MutablePropertyValues;true;getPropertyValue;;;Argument[-1].Element;ReturnValue;value",
        "org.springframework.beans;MutablePropertyValues;true;getPropertyValueList;;;Argument[-1].Element;ReturnValue.Element;value",
        "org.springframework.beans;MutablePropertyValues;true;getPropertyValues;;;Argument[-1].Element;ReturnValue.ArrayElement;value",
        "org.springframework.beans;MutablePropertyValues;true;setPropertyValueAt;;;Argument[0];Argument[-1].Element;value"
      ]
  }
}
