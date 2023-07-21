// Generated automatically from javafx.beans.binding.Binding for testing purposes

package javafx.beans.binding;

import javafx.beans.value.ObservableValue;
import javafx.collections.ObservableList;

public interface Binding<T> extends javafx.beans.value.ObservableValue<T>
{
    ObservableList<? extends Object> getDependencies();
    boolean isValid();
    void dispose();
    void invalidate();
}
