// Generated automatically from javafx.beans.binding.FloatBinding for testing purposes

package javafx.beans.binding;

import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.binding.FloatExpression;
import javafx.beans.binding.NumberBinding;
import javafx.beans.value.ChangeListener;
import javafx.collections.ObservableList;

abstract public class FloatBinding extends FloatExpression implements NumberBinding
{
    protected abstract float computeValue();
    protected final void bind(Observable... p0){}
    protected final void unbind(Observable... p0){}
    protected void onInvalidating(){}
    public FloatBinding(){}
    public ObservableList<? extends Object> getDependencies(){ return null; }
    public String toString(){ return null; }
    public final boolean isValid(){ return false; }
    public final float get(){ return 0; }
    public final void invalidate(){}
    public void addListener(ChangeListener<? super Number> p0){}
    public void addListener(InvalidationListener p0){}
    public void dispose(){}
    public void removeListener(ChangeListener<? super Number> p0){}
    public void removeListener(InvalidationListener p0){}
}
