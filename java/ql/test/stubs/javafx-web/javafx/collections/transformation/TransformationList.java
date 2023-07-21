// Generated automatically from javafx.collections.transformation.TransformationList for testing purposes

package javafx.collections.transformation;

import javafx.collections.ListChangeListener;
import javafx.collections.ObservableList;
import javafx.collections.ObservableListBase;

abstract public class TransformationList<E, F> extends javafx.collections.ObservableListBase<E>
{
    protected TransformationList() {}
    protected TransformationList(ObservableList<? extends F> p0){}
    protected abstract void sourceChanged(ListChangeListener.Change<? extends F> p0);
    public abstract int getSourceIndex(int p0);
    public abstract int getViewIndex(int p0);
    public final ObservableList<? extends F> getSource(){ return null; }
    public final boolean isInTransformationChain(ObservableList<? extends Object> p0){ return false; }
    public final int getSourceIndexFor(ObservableList<? extends Object> p0, int p1){ return 0; }
}
