// Generated automatically from javafx.collections.ObservableList for testing purposes

package javafx.collections;

import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import java.util.function.Predicate;
import javafx.beans.Observable;
import javafx.collections.ListChangeListener;
import javafx.collections.transformation.FilteredList;
import javafx.collections.transformation.SortedList;

public interface ObservableList<E> extends Observable, java.util.List<E>
{
    boolean addAll(E... p0);
    boolean removeAll(E... p0);
    boolean retainAll(E... p0);
    boolean setAll(E... p0);
    boolean setAll(java.util.Collection<? extends E> p0);
    default javafx.collections.transformation.FilteredList<E> filtered(java.util.function.Predicate<E> p0){ return null; }
    default javafx.collections.transformation.SortedList<E> sorted(){ return null; }
    default javafx.collections.transformation.SortedList<E> sorted(java.util.Comparator<E> p0){ return null; }
    void addListener(javafx.collections.ListChangeListener<? super E> p0);
    void remove(int p0, int p1);
    void removeListener(javafx.collections.ListChangeListener<? super E> p0);
}
