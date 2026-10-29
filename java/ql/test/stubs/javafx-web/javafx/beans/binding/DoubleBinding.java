// Generated automatically from javafx.beans.binding.DoubleBinding for testing purposes

package javafx.beans.binding;

import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.binding.DoubleExpression;
import javafx.beans.binding.NumberBinding;
import javafx.beans.value.ChangeListener;
import javafx.collections.ObservableList;

abstract public class DoubleBinding extends DoubleExpression implements NumberBinding
{
    protected abstract double computeValue();
    protected final void bind(Observable... p0){}
    protected final void unbind(Observable... p0){}
    protected void onInvalidating(){}
    public DoubleBinding(){}
    public ObservableList<? extends Object> getDependencies(){ return null; }
    public String toString(){ return null; }
    public final boolean isValid(){ return false; }
    public final double get(){ return 0; }
    public final void invalidate(){}
    public void addListener(ChangeListener<? super Number> p0){}
    public void addListener(InvalidationListener p0){}
    public void dispose(){}
    public void removeListener(ChangeListener<? super Number> p0){}
    public void removeListener(InvalidationListener p0){}
}
