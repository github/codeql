// Generated automatically from javafx.collections.ObservableMap for testing purposes

package javafx.collections;

import java.util.Map;
import javafx.beans.Observable;
import javafx.collections.MapChangeListener;

public interface ObservableMap<K, V> extends Observable, java.util.Map<K, V>
{
    void addListener(MapChangeListener<? super K, ? super V> p0);
    void removeListener(MapChangeListener<? super K, ? super V> p0);
}
