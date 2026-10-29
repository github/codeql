// Generated automatically from javafx.scene.Parent for testing purposes

package javafx.scene;

import java.util.List;
import javafx.beans.property.ReadOnlyBooleanProperty;
import javafx.collections.ObservableList;
import javafx.scene.AccessibleAttribute;
import javafx.scene.Node;

abstract public class Parent extends Node
{
    protected <E extends Node> java.util.List<E> getManagedChildren(){ return null; }
    protected ObservableList<Node> getChildren(){ return null; }
    protected Parent(){}
    protected double computeMinHeight(double p0){ return 0; }
    protected double computeMinWidth(double p0){ return 0; }
    protected double computePrefHeight(double p0){ return 0; }
    protected double computePrefWidth(double p0){ return 0; }
    protected final void requestParentLayout(){}
    protected final void setNeedsLayout(boolean p0){}
    protected void layoutChildren(){}
    protected void updateBounds(){}
    public Node lookup(String p0){ return null; }
    public Object queryAccessibleAttribute(AccessibleAttribute p0, Object... p1){ return null; }
    public ObservableList<Node> getChildrenUnmodifiable(){ return null; }
    public double getBaselineOffset(){ return 0; }
    public double minHeight(double p0){ return 0; }
    public double minWidth(double p0){ return 0; }
    public double prefHeight(double p0){ return 0; }
    public double prefWidth(double p0){ return 0; }
    public final ObservableList<String> getStylesheets(){ return null; }
    public final ReadOnlyBooleanProperty needsLayoutProperty(){ return null; }
    public final boolean isNeedsLayout(){ return false; }
    public final void layout(){}
    public void requestLayout(){}
}
