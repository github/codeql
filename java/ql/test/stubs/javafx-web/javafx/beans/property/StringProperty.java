// Generated automatically from javafx.beans.property.StringProperty for testing purposes

package javafx.beans.property;

import java.text.Format;
import javafx.beans.property.Property;
import javafx.beans.property.ReadOnlyStringProperty;
import javafx.beans.value.WritableStringValue;
import javafx.util.StringConverter;

abstract public class StringProperty extends ReadOnlyStringProperty implements Property<String>, WritableStringValue
{
    public <T> void bindBidirectional(javafx.beans.property.Property<T> p0, StringConverter<T> p1){}
    public String toString(){ return null; }
    public StringProperty(){}
    public void bindBidirectional(Property<? extends Object> p0, Format p1){}
    public void bindBidirectional(Property<String> p0){}
    public void setValue(String p0){}
    public void unbindBidirectional(Object p0){}
    public void unbindBidirectional(Property<String> p0){}
}
