package generatedtest;

import org.springframework.beans.PropertyValue;


public class Test {
    Object getMapKey(Object container) {
        return null;
    }

    Object getMapValue(Object container) {
        return null;
    }

    Object newWithMapKey(Object element) {
        return null;
    }

    Object newWithMapValue(Object element) {
        return null;
    }

    Object source() {
        return null;
    }

    void sink(Object o) {}

    public void test() {
        // @formatter:off
        // "org.springframework.beans;PropertyValue;false;;(String,Object);;Argument[0];MapKey of Argument[-1];value",
        {
            PropertyValue v = new PropertyValue((String) source(), null);
            sink(newWithMapKey(v)); // $hasValueFlow
            sink(newWithMapValue(v)); // Safe
        }
        // "org.springframework.beans;PropertyValue;false;;(String,Object);;Argument[1];MapValue of Argument[-1];value",
        {
            PropertyValue v = new PropertyValue("", source());
            sink(newWithMapKey(v)); // Safe
            sink(newWithMapValue(v)); // $hasValueFlow
        }
        // "org.springframework.beans;PropertyValue;false;;(PropertyValue);;Argument[0];Argument[-1];value",
        {
            PropertyValue v1 = new PropertyValue((String) source(), null);
            PropertyValue v2 = new PropertyValue(v1);
            sink(newWithMapKey(v2)); // $hasValueFlow
            sink(newWithMapValue(v2)); // Safe
            PropertyValue v3 = new PropertyValue("", source());
            PropertyValue v4 = new PropertyValue(v3);
            sink(newWithMapKey(v4)); // Safe
            sink(newWithMapValue(v4)); // $hasValueFlow
        }
        // "org.springframework.beans;PropertyValue;false;;(PropertyValue,Object);;MapKey of Argument[0];MapKey of Argument[-1];value",
        // "org.springframework.beans;PropertyValue;false;getName;;;MapKey of Argument[-1];ReturnValue;value",
        // "org.springframework.beans;PropertyValue;false;getValue;;;MapValue of Argument[-1];ReturnValue;value",
        // "org.springframework.beans;PropertyValues;true;getPropertyValue;;;MapValue of Argument[-1];ReturnValue;value",
        // "org.springframework.beans;PropertyValues;true;getPropertyValues;;;Element of Argument[-1];ArrayElement of ReturnValue;value",
        // "org.springframework.beans;MutablePropertyValues;true;add;(String,Object);;Argument[0];MapKey of Element of Argument[-1];value",
        // "org.springframework.beans;MutablePropertyValues;true;add;(String,Object);;Argument[0];MapKey of Element of ReturnValue;value",
        // "org.springframework.beans;MutablePropertyValues;true;add;(String,Object);;Argument[1];MapValue of Element of Argument[-1];value",
        // "org.springframework.beans;MutablePropertyValues;true;add;(String,Object);;Argument[1];MapValue of Element of ReturnValue;value",
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValue;(PropertyValue);;Argument[0];Element of Argument[-1];value",
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValue;(PropertyValue);;Argument[0];Element of ReturnValue;value",
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValue;(String,Object);;Argument[0];MapKey of Element of Argument[-1];value",
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValue;(String,Object);;Argument[1];MapValue of Element of Argument[-1];value",
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(Map);;MapKey of Argument[0];MapKey of Element of Argument[-1];value",
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(Map);;MapKey of Argument[0];MapKey of Element of ReturnValue;value",
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(Map);;MapValue of Argument[0];MapValue of Element of Argument[-1];value",
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(Map);;MapValue of Argument[0];MapValue of Element of ReturnValue;value",
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(PropertyValues);;MapKey of Element of Argument[0];MapKey of Element of Argument[-1];value",
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(PropertyValues);;MapKey of Element of Argument[0];MapKey of Element of ReturnValue;value",
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(PropertyValues);;MapValue of Element of Argument[0];MapValue of Element of Argument[-1];value",
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(PropertyValues);;MapValue of Element of Argument[0];MapValue of Element of ReturnValue;value",
        // "org.springframework.beans;MutablePropertyValues;true;get;;;MapValue of Element of Argument[-1];ReturnValue;value",
        // "org.springframework.beans;MutablePropertyValues;true;getPropertyValue;;;Element of Argument[-1];ReturnValue;value",
        // "org.springframework.beans;MutablePropertyValues;true;getPropertyValueList;;;Element of Argument[-1];Element of ReturnValue;value",
        // "org.springframework.beans;MutablePropertyValues;true;getPropertyValues;;;Element of Argument[-1];ArrayElement of ReturnValue;value",
        // "org.springframework.beans;MutablePropertyValues;true;setPropertyValueAt;;;Argument[0];Element of Argument[-1];value"
        // @formatter:on

    }
}
