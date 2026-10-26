// Generated automatically from javafx.css.StyleableProperty for testing purposes

package javafx.css;

import javafx.beans.value.WritableValue;
import javafx.css.CssMetaData;
import javafx.css.StyleOrigin;
import javafx.css.Styleable;

public interface StyleableProperty<T> extends javafx.beans.value.WritableValue<T>
{
    CssMetaData<? extends Styleable, T> getCssMetaData();
    StyleOrigin getStyleOrigin();
    void applyStyle(StyleOrigin p0, T p1);
}
