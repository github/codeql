// Generated automatically from javafx.collections.ListChangeListener for testing purposes

package javafx.collections;

import java.util.List;
import javafx.collections.ObservableList;

public interface ListChangeListener<E>
{
    abstract static public class Change<E>
    {
        protected Change() {}
        protected abstract int[] getPermutation();
        public Change(javafx.collections.ObservableList<E> p0){}
        public abstract boolean next();
        public abstract int getFrom();
        public abstract int getTo();
        public abstract java.util.List<E> getRemoved();
        public abstract void reset();
        public boolean wasAdded(){ return false; }
        public boolean wasPermutated(){ return false; }
        public boolean wasRemoved(){ return false; }
        public boolean wasReplaced(){ return false; }
        public boolean wasUpdated(){ return false; }
        public int getAddedSize(){ return 0; }
        public int getPermutation(int p0){ return 0; }
        public int getRemovedSize(){ return 0; }
        public java.util.List<E> getAddedSubList(){ return null; }
        public javafx.collections.ObservableList<E> getList(){ return null; }
    }
    void onChanged(ListChangeListener.Change<? extends E> p0);
}
