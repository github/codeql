// Generated automatically from javafx.collections.ObservableListBase for testing purposes

package javafx.collections;

import java.util.AbstractList;
import java.util.Collection;
import java.util.List;
import javafx.beans.InvalidationListener;
import javafx.collections.ListChangeListener;
import javafx.collections.ObservableList;

abstract public class ObservableListBase<E> extends java.util.AbstractList<E> implements javafx.collections.ObservableList<E>
{
    protected final boolean hasListeners(){ return false; }
    protected final void beginChange(){}
    protected final void endChange(){}
    protected final void fireChange(ListChangeListener.Change<? extends E> p0){}
    protected final void nextAdd(int p0, int p1){}
    protected final void nextPermutation(int p0, int p1, int[] p2){}
    protected final void nextRemove(int p0, E p1){}
    protected final void nextRemove(int p0, java.util.List<? extends E> p1){}
    protected final void nextReplace(int p0, int p1, java.util.List<? extends E> p2){}
    protected final void nextSet(int p0, E p1){}
    protected final void nextUpdate(int p0){}
    public ObservableListBase(){}
    public boolean addAll(E... p0){ return false; }
    public boolean removeAll(E... p0){ return false; }
    public boolean retainAll(E... p0){ return false; }
    public boolean setAll(E... p0){ return false; }
    public boolean setAll(java.util.Collection<? extends E> p0){ return false; }
    public final void addListener(InvalidationListener p0){}
    public final void addListener(javafx.collections.ListChangeListener<? super E> p0){}
    public final void removeListener(InvalidationListener p0){}
    public final void removeListener(javafx.collections.ListChangeListener<? super E> p0){}
    public void remove(int p0, int p1){}
}
