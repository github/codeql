// Generated automatically from javafx.css.CssMetaData for testing purposes

package javafx.css;

import java.util.List;
import javafx.css.StyleConverter;
import javafx.css.StyleOrigin;
import javafx.css.Styleable;
import javafx.css.StyleableProperty;

abstract public class CssMetaData<S extends Styleable, V>
{
    protected CssMetaData() {}
    protected CssMetaData(String p0, StyleConverter<? extends Object, V> p1){}
    protected CssMetaData(String p0, StyleConverter<? extends Object, V> p1, V p2){}
    protected CssMetaData(String p0, StyleConverter<? extends Object, V> p1, V p2, boolean p3){}
    protected CssMetaData(String p0, StyleConverter<? extends Object, V> p1, V p2, boolean p3, List<CssMetaData<? extends Styleable, ? extends Object>> p4){}
    public String toString(){ return null; }
    public V getInitialValue(S p0){ return null; }
    public abstract StyleableProperty<V> getStyleableProperty(S p0);
    public abstract boolean isSettable(S p0);
    public boolean equals(Object p0){ return false; }
    public final List<CssMetaData<? extends Styleable, ? extends Object>> getSubProperties(){ return null; }
    public final String getProperty(){ return null; }
    public final StyleConverter<? extends Object, V> getConverter(){ return null; }
    public final boolean isInherits(){ return false; }
    public int hashCode(){ return 0; }
    public void set(S p0, V p1, StyleOrigin p2){}
}
