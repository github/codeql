// Generated automatically from javafx.beans.property.Property for testing purposes

package javafx.beans.property;

import javafx.beans.property.ReadOnlyProperty;
import javafx.beans.value.ObservableValue;
import javafx.beans.value.WritableValue;

public interface Property<T> extends javafx.beans.property.ReadOnlyProperty<T>, javafx.beans.value.WritableValue<T>
{
    boolean isBound();
    void bind(javafx.beans.value.ObservableValue<? extends T> p0);
    void bindBidirectional(Property<T> p0);
    void unbind();
    void unbindBidirectional(Property<T> p0);
}
