// Generated automatically from org.springframework.beans.PropertyValues for testing purposes

package org.springframework.beans;

import java.util.Iterator;
import java.util.Spliterator;
import java.util.stream.Stream;
import org.springframework.beans.PropertyValue;

public interface PropertyValues extends Iterable<PropertyValue>
{
    PropertyValue getPropertyValue(String p0);
    PropertyValue[] getPropertyValues();
    PropertyValues changesSince(PropertyValues p0);
    boolean contains(String p0);
    boolean isEmpty();
    default Iterator<PropertyValue> iterator(){ return null; }
    default Spliterator<PropertyValue> spliterator(){ return null; }
    default Stream<PropertyValue> stream(){ return null; }
}
