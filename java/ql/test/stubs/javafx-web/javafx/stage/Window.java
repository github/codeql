// Generated automatically from javafx.stage.Window for testing purposes

package javafx.stage;

import javafx.beans.property.BooleanProperty;
import javafx.beans.property.DoubleProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.ReadOnlyBooleanProperty;
import javafx.beans.property.ReadOnlyDoubleProperty;
import javafx.beans.property.ReadOnlyObjectProperty;
import javafx.collections.ObservableList;
import javafx.collections.ObservableMap;
import javafx.event.Event;
import javafx.event.EventDispatchChain;
import javafx.event.EventDispatcher;
import javafx.event.EventHandler;
import javafx.event.EventTarget;
import javafx.event.EventType;
import javafx.scene.Scene;
import javafx.stage.WindowEvent;

public class Window implements EventTarget
{
    protected Window(){}
    protected final <T extends Event> void setEventHandler(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    protected void setScene(Scene p0){}
    protected void show(){}
    public EventDispatchChain buildEventDispatchChain(EventDispatchChain p0){ return null; }
    public Object getUserData(){ return null; }
    public boolean hasProperties(){ return false; }
    public final <T extends Event> void addEventFilter(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final <T extends Event> void addEventHandler(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final <T extends Event> void removeEventFilter(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final <T extends Event> void removeEventHandler(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final BooleanProperty forceIntegerRenderScaleProperty(){ return null; }
    public final DoubleProperty opacityProperty(){ return null; }
    public final DoubleProperty renderScaleXProperty(){ return null; }
    public final DoubleProperty renderScaleYProperty(){ return null; }
    public final EventDispatcher getEventDispatcher(){ return null; }
    public final EventHandler<WindowEvent> getOnCloseRequest(){ return null; }
    public final EventHandler<WindowEvent> getOnHidden(){ return null; }
    public final EventHandler<WindowEvent> getOnHiding(){ return null; }
    public final EventHandler<WindowEvent> getOnShowing(){ return null; }
    public final EventHandler<WindowEvent> getOnShown(){ return null; }
    public final ObjectProperty<EventDispatcher> eventDispatcherProperty(){ return null; }
    public final ObjectProperty<EventHandler<WindowEvent>> onCloseRequestProperty(){ return null; }
    public final ObjectProperty<EventHandler<WindowEvent>> onHiddenProperty(){ return null; }
    public final ObjectProperty<EventHandler<WindowEvent>> onHidingProperty(){ return null; }
    public final ObjectProperty<EventHandler<WindowEvent>> onShowingProperty(){ return null; }
    public final ObjectProperty<EventHandler<WindowEvent>> onShownProperty(){ return null; }
    public final ObservableMap<Object, Object> getProperties(){ return null; }
    public final ReadOnlyBooleanProperty focusedProperty(){ return null; }
    public final ReadOnlyBooleanProperty showingProperty(){ return null; }
    public final ReadOnlyDoubleProperty heightProperty(){ return null; }
    public final ReadOnlyDoubleProperty outputScaleXProperty(){ return null; }
    public final ReadOnlyDoubleProperty outputScaleYProperty(){ return null; }
    public final ReadOnlyDoubleProperty widthProperty(){ return null; }
    public final ReadOnlyDoubleProperty xProperty(){ return null; }
    public final ReadOnlyDoubleProperty yProperty(){ return null; }
    public final ReadOnlyObjectProperty<Scene> sceneProperty(){ return null; }
    public final Scene getScene(){ return null; }
    public final boolean isFocused(){ return false; }
    public final boolean isForceIntegerRenderScale(){ return false; }
    public final boolean isShowing(){ return false; }
    public final double getHeight(){ return 0; }
    public final double getOpacity(){ return 0; }
    public final double getOutputScaleX(){ return 0; }
    public final double getOutputScaleY(){ return 0; }
    public final double getRenderScaleX(){ return 0; }
    public final double getRenderScaleY(){ return 0; }
    public final double getWidth(){ return 0; }
    public final double getX(){ return 0; }
    public final double getY(){ return 0; }
    public final void fireEvent(Event p0){}
    public final void requestFocus(){}
    public final void setEventDispatcher(EventDispatcher p0){}
    public final void setForceIntegerRenderScale(boolean p0){}
    public final void setHeight(double p0){}
    public final void setOnCloseRequest(EventHandler<WindowEvent> p0){}
    public final void setOnHidden(EventHandler<WindowEvent> p0){}
    public final void setOnHiding(EventHandler<WindowEvent> p0){}
    public final void setOnShowing(EventHandler<WindowEvent> p0){}
    public final void setOnShown(EventHandler<WindowEvent> p0){}
    public final void setOpacity(double p0){}
    public final void setRenderScaleX(double p0){}
    public final void setRenderScaleY(double p0){}
    public final void setWidth(double p0){}
    public final void setX(double p0){}
    public final void setY(double p0){}
    public static ObservableList<Window> getWindows(){ return null; }
    public void centerOnScreen(){}
    public void hide(){}
    public void setUserData(Object p0){}
    public void sizeToScene(){}
}
