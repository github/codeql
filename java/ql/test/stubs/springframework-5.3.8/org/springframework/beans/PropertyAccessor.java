// Generated automatically from org.springframework.beans.PropertyAccessor for testing purposes

package org.springframework.beans;

import java.util.Map;
import org.springframework.beans.PropertyValue;
import org.springframework.beans.PropertyValues;
import org.springframework.core.convert.TypeDescriptor;

public interface PropertyAccessor
{
    Class<? extends Object> getPropertyType(String p0);
    Object getPropertyValue(String p0);
    TypeDescriptor getPropertyTypeDescriptor(String p0);
    boolean isReadableProperty(String p0);
    boolean isWritableProperty(String p0);
    static String NESTED_PROPERTY_SEPARATOR = null;
    static String PROPERTY_KEY_PREFIX = null;
    static String PROPERTY_KEY_SUFFIX = null;
    static char NESTED_PROPERTY_SEPARATOR_CHAR = '0';
    static char PROPERTY_KEY_PREFIX_CHAR = '0';
    static char PROPERTY_KEY_SUFFIX_CHAR = '0';
    void setPropertyValue(PropertyValue p0);
    void setPropertyValue(String p0, Object p1);
    void setPropertyValues(Map<? extends Object, ? extends Object> p0);
    void setPropertyValues(PropertyValues p0);
    void setPropertyValues(PropertyValues p0, boolean p1);
    void setPropertyValues(PropertyValues p0, boolean p1, boolean p2);
}
