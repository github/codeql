package generatedtest;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.PropertyValue;
import org.springframework.beans.PropertyValues;


public class Test {
    Object getMapKey(PropertyValue container) {
        return container.getName();
    }

    Object getMapValue(PropertyValue container) {
        return container.getValue();
    }

    PropertyValue getElement(Iterable<PropertyValue> container) {
        return container.iterator().next();
    }

    PropertyValue getArrayElement(PropertyValue[] container) {
        return container[0];
    }

    PropertyValue newWithMapKey(String element) {
        return new PropertyValue(element, null);
    }

    PropertyValue newWithMapValue(String element) {
        return new PropertyValue("", element);
    }

    MutablePropertyValues newWithElement(PropertyValue element) {
        MutablePropertyValues pv = new MutablePropertyValues();
        pv.addPropertyValue(element);
        return pv;
    }

    String source() {
        return null;
    }

    void sink(Object o) {}

    public void test() {
        // @formatter:off
        // "org.springframework.beans;PropertyValue;false;;(String,Object);;Argument[0];MapKey of Argument[-1];value",
        {
            PropertyValue v = new PropertyValue((String) source(), null);
            sink(getMapKey(v)); // $hasValueFlow
            sink(getMapValue(v)); // Safe
        }
        // "org.springframework.beans;PropertyValue;false;;(String,Object);;Argument[1];MapValue of Argument[-1];value",
        {
            PropertyValue v = new PropertyValue("", source());
            sink(getMapKey(v)); // Safe
            sink(getMapValue(v)); // $hasValueFlow
        }
        // "org.springframework.beans;PropertyValue;false;;(PropertyValue);;Argument[0];Argument[-1];value",
        {
            PropertyValue v1 = new PropertyValue((String) source(), null);
            PropertyValue v2 = new PropertyValue(v1);
            sink(getMapKey(v2)); // $hasValueFlow
            sink(getMapValue(v2)); // Safe

            PropertyValue v3 = new PropertyValue("safe", source());
            PropertyValue v4 = new PropertyValue(v3);
            sink(getMapKey(v4)); // Safe
            sink(getMapValue(v4)); // $hasValueFlow
        }
        // "org.springframework.beans;PropertyValue;false;;(PropertyValue,Object);;MapKey of Argument[0];MapKey of Argument[-1];value",
        {
            PropertyValue v1 = new PropertyValue((String) source(), source());
            PropertyValue v2 = new PropertyValue(v1, null);
            sink(getMapKey(v2)); // $hasValueFlow
            sink(getMapValue(v2)); // Safe
        }
        // "org.springframework.beans;PropertyValue;false;PropertyValue;(PropertyValue,Object);;Argument[1];MapValue of Argument[-1];value",
        {
            PropertyValue v1 = new PropertyValue("safe", null);
            PropertyValue v2 = new PropertyValue(v1, source());
            sink(getMapKey(v2)); // Safe
            sink(getMapValue(v2)); // $hasValueFlow
        }
        // "org.springframework.beans;PropertyValue;false;getName;;;MapKey of Argument[-1];ReturnValue;value",
        {
            PropertyValue v = new PropertyValue((String) source(), null);
            sink(v.getName()); // $hasValueFlow
            sink(v.getValue()); // Safe
        }
        // "org.springframework.beans;PropertyValue;false;getValue;;;MapValue of Argument[-1];ReturnValue;value",
        {
            PropertyValue v = new PropertyValue("safe", source());
            sink(v.getName()); // Safe
            sink(v.getValue()); // $hasValueFlow
        }
        // "org.springframework.beans;PropertyValues;true;getPropertyValue;;;Element of Argument[-1];ReturnValue;value",
        {
            PropertyValues pv = newWithElement(newWithMapValue(source()));
            sink(pv.getPropertyValue("safe").getValue()); // $hasValueFlow
        }
        // "org.springframework.beans;PropertyValues;true;getPropertyValues;;;Element of Argument[-1];ArrayElement of ReturnValue;value",
        {
            PropertyValues pv = newWithElement(newWithMapValue(source()));
            PropertyValue[] vs = pv.getPropertyValues();
            sink(getMapKey(getArrayElement(vs))); // Safe
            sink(getMapValue(getArrayElement(vs))); // $hasValueFlow
        }
        // "org.springframework.beans;MutablePropertyValues;true;add;(String,Object);;Argument[0];MapKey of Element of Argument[-1];value",
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            pv.add((String) source(), null);
            sink(getMapKey(getElement(pv))); // $hasValueFlow
            sink(getMapValue(getElement(pv))); // Safe
        }
        // "org.springframework.beans;MutablePropertyValues;true;add;(String,Object);;Argument[-1];ReturnValue;value",
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            sink(getMapKey(getElement(pv.add(source(), null)))); // $hasValueFlow
            sink(getMapValue(getElement(pv.add(source(), null)))); // Safe
        }
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            sink(getMapKey(getElement(pv.add("safe", source())))); // Safe
            sink(getMapValue(getElement(pv.add("safe", source())))); // $hasValueFlow
        }
        // "org.springframework.beans;MutablePropertyValues;true;add;(String,Object);;Argument[1];MapValue of Element of Argument[-1];value",
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            pv.add("safe", source());
            sink(getMapKey(getElement(pv))); // Safe
            sink(getMapValue(getElement(pv))); // $hasValueFlow
        }
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValue;(PropertyValue);;Argument[0];Element of Argument[-1];value",
        {
            MutablePropertyValues pv1 = new MutablePropertyValues();
            PropertyValue v1 = newWithMapKey(source());
            pv1.addPropertyValue(v1);
            sink(getMapKey(getElement(pv1))); // $hasValueFlow
            sink(getMapValue(getElement(pv1))); // Safe

            MutablePropertyValues pv2 = new MutablePropertyValues();
            PropertyValue v2 = newWithMapValue(source());
            pv2.addPropertyValue(v2);
            sink(getMapKey(getElement(pv2))); // Safe
            sink(getMapValue(getElement(pv2))); // $hasValueFlow
        }
        //  "org.springframework.beans;MutablePropertyValues;true;addPropertyValue;(PropertyValue);;Argument[-1];ReturnValue;value",
        {
            MutablePropertyValues pv1 = new MutablePropertyValues();
            PropertyValue v1 = newWithMapKey(source());
            PropertyValues pv2 = pv1.addPropertyValue(v1);
            sink(getMapKey(getElement(pv2))); // $hasValueFlow
            sink(getMapValue(getElement(pv2))); // Safe

            MutablePropertyValues pv3 = new MutablePropertyValues();
            PropertyValue v2 = newWithMapValue(source());
            PropertyValues pv4 = pv3.addPropertyValue(v2);
            sink(getMapKey(getElement(pv4))); // Safe
            sink(getMapValue(getElement(pv4))); // $hasValueFlow
        }
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValue;(String,Object);;Argument[0];MapKey of Element of Argument[-1];value",
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            pv.addPropertyValue((String)source(), null);
            sink(getMapKey(getElement(pv))); // $hasValueFlow
            sink(getMapValue(getElement(pv))); // Safe
        }
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValue;(String,Object);;Argument[1];MapValue of Element of Argument[-1];value",
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            pv.addPropertyValue("safe", source());
            sink(getMapKey(getElement(pv))); // Safe
            sink(getMapValue(getElement(pv))); // $hasValueFlow
        }
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(Map);;MapKey of Argument[0];MapKey of Element of Argument[-1];value",
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            Map<String, Object> values = new HashMap<String, Object>();
            values.put(source(), null);
            pv.addPropertyValues(values);
            sink(getMapKey(getElement(pv))); // $hasValueFlow
            sink(getMapValue(getElement(pv))); // Safe
        }
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(Map);;MapValue of Argument[0];MapValue of Element of Argument[-1];value",
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            Map<String, Object> values = new HashMap<String, Object>();
            values.put("", source());
            pv.addPropertyValues(values);
            sink(getMapKey(getElement(pv))); // Safe
            sink(getMapValue(getElement(pv))); // $hasValueFlow
        }
        //  "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(Map);;Argument[-1];ReturnValue;value",
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            Map<String, Object> values = new HashMap<String, Object>();
            values.put("", source());
            PropertyValues pv2 = pv.addPropertyValues(values);
            sink(getMapKey(getElement(pv2))); // Safe
            sink(getMapValue(getElement(pv2))); // $hasValueFlow
        }
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            Map<String, Object> values = new HashMap<String, Object>();
            values.put(source(), null);
            PropertyValues pv2 = pv.addPropertyValues(values);
            sink(getMapKey(getElement(pv2))); // $hasValueFlow
            sink(getMapValue(getElement(pv2))); // Safe
        }
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(PropertyValues);;Element of Argument[0];Element of Argument[-1];value",
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            PropertyValues values = newWithElement(newWithMapKey(source()));
            pv.addPropertyValues(values);
            sink(getMapKey(getElement(pv))); // $hasValueFlow
            sink(getMapValue(getElement(pv))); // Safe
        }
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            PropertyValues values = newWithElement(newWithMapValue(source()));
            pv.addPropertyValues(values);
            sink(getMapKey(getElement(pv))); // Safe
            sink(getMapValue(getElement(pv))); // $hasValueFlow
        }
        // "org.springframework.beans;MutablePropertyValues;true;addPropertyValues;(PropertyValues);;Argument[-1];ReturnValue;value",
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            PropertyValues values = newWithElement(newWithMapKey(source()));
            PropertyValues pv2 = pv.addPropertyValues(values);
            sink(getMapKey(getElement(pv2))); // $hasValueFlow
            sink(getMapValue(getElement(pv2))); // Safe
        }
        {
            MutablePropertyValues pv = new MutablePropertyValues();
            PropertyValues values = newWithElement(newWithMapValue(source()));
            PropertyValues pv2 = pv.addPropertyValues(values);
            sink(getMapKey(getElement(pv2))); // Safe
            sink(getMapValue(getElement(pv2))); // $hasValueFlow
        }
        // "org.springframework.beans;MutablePropertyValues;true;get;;;MapValue of Element of Argument[-1];ReturnValue;value",
        {
            MutablePropertyValues pv = newWithElement(newWithMapValue(source()));
            sink(pv.get("something")); // $hasValueFlow
        }
        // "org.springframework.beans;MutablePropertyValues;true;getPropertyValue;;;Element of Argument[-1];ReturnValue;value",
        {
            MutablePropertyValues pv1 = newWithElement(newWithMapKey(source()));
            sink(pv1.getPropertyValue("something").getName()); // $hasValueFlow
            sink(pv1.getPropertyValue("something").getValue()); // Safe

            MutablePropertyValues pv2 = newWithElement(newWithMapValue(source()));
            sink(pv2.getPropertyValue("something").getName()); // Safe
            sink(pv2.getPropertyValue("something").getValue()); // $hasValueFlow
        }
        // "org.springframework.beans;MutablePropertyValues;true;getPropertyValueList;;;Element of Argument[-1];Element of ReturnValue;value",
        {
            MutablePropertyValues pv1 = newWithElement(newWithMapKey(source()));
            List<PropertyValue> pvl1 = pv1.getPropertyValueList();
            sink(getMapKey(getElement(pvl1))); // $hasValueFlow
            sink(getMapValue(getElement(pvl1))); // Safe

            MutablePropertyValues pv2 = newWithElement(newWithMapValue(source()));
            List<PropertyValue> pvl2 = pv2.getPropertyValueList();
            sink(getMapKey(getElement(pvl2))); // Safe
            sink(getMapValue(getElement(pvl2))); // $hasValueFlow
        }
        // "org.springframework.beans;MutablePropertyValues;true;getPropertyValues;;;Element of Argument[-1];ArrayElement of ReturnValue;value",
        {
            MutablePropertyValues pv1 = newWithElement(newWithMapKey(source()));
            PropertyValue[] pvl1 = pv1.getPropertyValues();
            sink(getMapKey(getArrayElement(pvl1))); // $hasValueFlow
            sink(getMapValue(getArrayElement(pvl1))); // Safe

            MutablePropertyValues pv2 = newWithElement(newWithMapValue(source()));
            PropertyValue[] pvl2 = pv2.getPropertyValues();
            sink(getMapKey(getArrayElement(pvl2))); // Safe
            sink(getMapValue(getArrayElement(pvl2))); // $hasValueFlow
        }
        // "org.springframework.beans;MutablePropertyValues;true;setPropertyValueAt;;;Argument[0];Element of Argument[-1];value"
        {
            MutablePropertyValues pv1 = new MutablePropertyValues();
            PropertyValue v1 = newWithMapKey(source());
            pv1.setPropertyValueAt(v1, 0);
            sink(getMapKey(getElement(pv1))); // $hasValueFlow
            sink(getMapValue(getElement(pv1))); // Safe

            MutablePropertyValues pv2 = new MutablePropertyValues();
            PropertyValue v2 = newWithMapValue(source());
            pv2.setPropertyValueAt(v2, 0);
            sink(getMapKey(getElement(pv2))); // Safe
            sink(getMapValue(getElement(pv2))); // $hasValueFlow
        }
        // @formatter:on
    }
}
