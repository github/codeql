// Generated automatically from javafx.collections.SetChangeListener for testing purposes

package javafx.collections;

import javafx.collections.ObservableSet;

public interface SetChangeListener<E>
{
    abstract static public class Change<E>
    {
        protected Change() {}
        public Change(ObservableSet<E> p0){}
        public ObservableSet<E> getSet(){ return null; }
        public abstract E getElementAdded();
        public abstract E getElementRemoved();
        public abstract boolean wasAdded();
        public abstract boolean wasRemoved();
    }
    void onChanged(SetChangeListener.Change<? extends E> p0);
}
