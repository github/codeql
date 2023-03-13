// Generated automatically from javafx.collections.ObservableSet for testing purposes

package javafx.collections;

import java.util.Set;
import javafx.beans.Observable;
import javafx.collections.SetChangeListener;

public interface ObservableSet<E> extends Observable, java.util.Set<E>
{
    void addListener(SetChangeListener<? super E> p0);
    void removeListener(SetChangeListener<? super E> p0);
}
