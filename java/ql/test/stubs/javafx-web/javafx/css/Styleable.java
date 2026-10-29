// Generated automatically from javafx.css.Styleable for testing purposes

package javafx.css;

import java.util.List;
import javafx.collections.ObservableList;
import javafx.collections.ObservableSet;
import javafx.css.CssMetaData;
import javafx.css.PseudoClass;
import javafx.scene.Node;

public interface Styleable
{
    List<CssMetaData<? extends Styleable, ? extends Object>> getCssMetaData();
    ObservableList<String> getStyleClass();
    ObservableSet<PseudoClass> getPseudoClassStates();
    String getId();
    String getStyle();
    String getTypeSelector();
    Styleable getStyleableParent();
    default Node getStyleableNode(){ return null; }
}
