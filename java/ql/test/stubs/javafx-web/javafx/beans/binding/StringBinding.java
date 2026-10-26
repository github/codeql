// Generated automatically from javafx.beans.binding.StringBinding for testing purposes

package javafx.beans.binding;

import javafx.beans.InvalidationListener;
import javafx.beans.Observable;
import javafx.beans.binding.Binding;
import javafx.beans.binding.StringExpression;
import javafx.beans.value.ChangeListener;
import javafx.collections.ObservableList;

abstract public class StringBinding extends StringExpression implements Binding<String>
{
    protected abstract String computeValue();
    protected final void bind(Observable... p0){}
    protected final void unbind(Observable... p0){}
    protected void onInvalidating(){}
    public ObservableList<? extends Object> getDependencies(){ return null; }
    public String toString(){ return null; }
    public StringBinding(){}
    public final String get(){ return null; }
    public final boolean isValid(){ return false; }
    public final void invalidate(){}
    public void addListener(ChangeListener<? super String> p0){}
    public void addListener(InvalidationListener p0){}
    public void dispose(){}
    public void removeListener(ChangeListener<? super String> p0){}
    public void removeListener(InvalidationListener p0){}
}
