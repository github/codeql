// Generated automatically from javafx.collections.MapChangeListener for testing purposes

package javafx.collections;

import javafx.collections.ObservableMap;

public interface MapChangeListener<K, V>
{
    abstract static public class Change<K, V>
    {
        protected Change() {}
        public Change(ObservableMap<K, V> p0){}
        public ObservableMap<K, V> getMap(){ return null; }
        public abstract K getKey();
        public abstract V getValueAdded();
        public abstract V getValueRemoved();
        public abstract boolean wasAdded();
        public abstract boolean wasRemoved();
    }
    void onChanged(MapChangeListener.Change<? extends K, ? extends V> p0);
}
