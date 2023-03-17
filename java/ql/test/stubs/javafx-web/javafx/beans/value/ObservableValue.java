// Generated automatically from javafx.beans.value.ObservableValue for testing purposes

package javafx.beans.value;

import java.util.function.Function;
import javafx.beans.Observable;
import javafx.beans.value.ChangeListener;

public interface ObservableValue<T> extends Observable
{
    T getValue();
    default <U> javafx.beans.value.ObservableValue<U> flatMap(java.util.function.Function<? super T, ? extends ObservableValue<? extends U>> p0){ return null; }
    default <U> javafx.beans.value.ObservableValue<U> map(java.util.function.Function<? super T, ? extends U> p0){ return null; }
    default ObservableValue<T> orElse(T p0){ return null; }
    default ObservableValue<T> when(ObservableValue<Boolean> p0){ return null; }
    void addListener(javafx.beans.value.ChangeListener<? super T> p0);
    void removeListener(javafx.beans.value.ChangeListener<? super T> p0);
}
