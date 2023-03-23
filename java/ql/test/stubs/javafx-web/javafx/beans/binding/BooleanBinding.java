// Generated automatically from javafx.beans.binding.BooleanBinding for testing purposes

package javafx.beans.binding;

import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.binding.Binding;
import javafx.beans.binding.BooleanExpression;
import javafx.beans.value.ChangeListener;
import javafx.collections.ObservableList;

abstract public class BooleanBinding extends BooleanExpression implements Binding<Boolean>
{
    protected abstract boolean computeValue();
    protected final void bind(Observable... p0){}
    protected final void unbind(Observable... p0){}
    protected void onInvalidating(){}
    public BooleanBinding(){}
    public ObservableList<? extends Object> getDependencies(){ return null; }
    public String toString(){ return null; }
    public final boolean get(){ return false; }
    public final boolean isValid(){ return false; }
    public final void invalidate(){}
    public void addListener(ChangeListener<? super Boolean> p0){}
    public void addListener(InvalidationListener p0){}
    public void dispose(){}
    public void removeListener(ChangeListener<? super Boolean> p0){}
    public void removeListener(InvalidationListener p0){}
}
