// Generated automatically from javafx.collections.transformation.FilteredList for testing purposes

package javafx.collections.transformation;

import java.util.function.Predicate;
import javafx.beans.property.ObjectProperty;
import javafx.collections.ListChangeListener;
import javafx.collections.ObservableList;
import javafx.collections.transformation.TransformationList;

public class FilteredList<E> extends javafx.collections.transformation.TransformationList<E, E>
{
    protected FilteredList() {}
    protected void sourceChanged(ListChangeListener.Change<? extends E> p0){}
    public E get(int p0){ return null; }
    public FilteredList(javafx.collections.ObservableList<E> p0){}
    public FilteredList(javafx.collections.ObservableList<E> p0, java.util.function.Predicate<? super E> p1){}
    public final ObjectProperty<java.util.function.Predicate<? super E>> predicateProperty(){ return null; }
    public final java.util.function.Predicate<? super E> getPredicate(){ return null; }
    public final void setPredicate(java.util.function.Predicate<? super E> p0){}
    public int getSourceIndex(int p0){ return 0; }
    public int getViewIndex(int p0){ return 0; }
    public int size(){ return 0; }
}
