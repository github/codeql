// Generated automatically from javafx.scene.Scene for testing purposes

package javafx.scene;

import com.sun.javafx.tk.TKClipboard;
import com.sun.javafx.tk.TKDragGestureListener;
import com.sun.javafx.tk.TKPulseListener;
import javafx.beans.property.ObjectProperty;
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
import javafx.geometry.NodeOrientation;
import javafx.scene.Camera;
import javafx.scene.Cursor;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.SceneAntialiasing;
import javafx.scene.SnapshotResult;
import javafx.scene.image.WritableImage;
import javafx.scene.input.ContextMenuEvent;
import javafx.scene.input.DragEvent;
import javafx.scene.input.Dragboard;
import javafx.scene.input.InputMethodEvent;
import javafx.scene.input.KeyCombination;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.Mnemonic;
import javafx.scene.input.MouseDragEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.RotateEvent;
import javafx.scene.input.ScrollEvent;
import javafx.scene.input.SwipeEvent;
import javafx.scene.input.TouchEvent;
import javafx.scene.input.TransferMode;
import javafx.scene.input.ZoomEvent;
import javafx.scene.paint.Paint;
import javafx.stage.Window;
import javafx.util.Callback;

public class Scene implements EventTarget
{
    protected Scene() {}
    protected final <T extends Event> void setEventHandler(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public Dragboard startDragAndDrop(TransferMode... p0){ return null; }
    public EventDispatchChain buildEventDispatchChain(EventDispatchChain p0){ return null; }
    public Node lookup(String p0){ return null; }
    public Object getUserData(){ return null; }
    public ObservableMap<KeyCombination, ObservableList<Mnemonic>> getMnemonics(){ return null; }
    public ObservableMap<KeyCombination, Runnable> getAccelerators(){ return null; }
    public Scene(Parent p0){}
    public Scene(Parent p0, Paint p1){}
    public Scene(Parent p0, double p1, double p2){}
    public Scene(Parent p0, double p1, double p2, Paint p3){}
    public Scene(Parent p0, double p1, double p2, boolean p3){}
    public Scene(Parent p0, double p1, double p2, boolean p3, SceneAntialiasing p4){}
    public WritableImage snapshot(WritableImage p0){ return null; }
    public boolean hasProperties(){ return false; }
    public final <T extends Event> void addEventFilter(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final <T extends Event> void addEventHandler(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final <T extends Event> void removeEventFilter(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final <T extends Event> void removeEventHandler(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final Camera getCamera(){ return null; }
    public final Cursor getCursor(){ return null; }
    public final EventDispatcher getEventDispatcher(){ return null; }
    public final EventHandler<? super ContextMenuEvent> getOnContextMenuRequested(){ return null; }
    public final EventHandler<? super DragEvent> getOnDragDone(){ return null; }
    public final EventHandler<? super DragEvent> getOnDragDropped(){ return null; }
    public final EventHandler<? super DragEvent> getOnDragEntered(){ return null; }
    public final EventHandler<? super DragEvent> getOnDragExited(){ return null; }
    public final EventHandler<? super DragEvent> getOnDragOver(){ return null; }
    public final EventHandler<? super InputMethodEvent> getOnInputMethodTextChanged(){ return null; }
    public final EventHandler<? super KeyEvent> getOnKeyPressed(){ return null; }
    public final EventHandler<? super KeyEvent> getOnKeyReleased(){ return null; }
    public final EventHandler<? super KeyEvent> getOnKeyTyped(){ return null; }
    public final EventHandler<? super MouseDragEvent> getOnMouseDragEntered(){ return null; }
    public final EventHandler<? super MouseDragEvent> getOnMouseDragExited(){ return null; }
    public final EventHandler<? super MouseDragEvent> getOnMouseDragOver(){ return null; }
    public final EventHandler<? super MouseDragEvent> getOnMouseDragReleased(){ return null; }
    public final EventHandler<? super MouseEvent> getOnDragDetected(){ return null; }
    public final EventHandler<? super MouseEvent> getOnMouseClicked(){ return null; }
    public final EventHandler<? super MouseEvent> getOnMouseDragged(){ return null; }
    public final EventHandler<? super MouseEvent> getOnMouseEntered(){ return null; }
    public final EventHandler<? super MouseEvent> getOnMouseExited(){ return null; }
    public final EventHandler<? super MouseEvent> getOnMouseMoved(){ return null; }
    public final EventHandler<? super MouseEvent> getOnMousePressed(){ return null; }
    public final EventHandler<? super MouseEvent> getOnMouseReleased(){ return null; }
    public final EventHandler<? super RotateEvent> getOnRotate(){ return null; }
    public final EventHandler<? super RotateEvent> getOnRotationFinished(){ return null; }
    public final EventHandler<? super RotateEvent> getOnRotationStarted(){ return null; }
    public final EventHandler<? super ScrollEvent> getOnScroll(){ return null; }
    public final EventHandler<? super ScrollEvent> getOnScrollFinished(){ return null; }
    public final EventHandler<? super ScrollEvent> getOnScrollStarted(){ return null; }
    public final EventHandler<? super SwipeEvent> getOnSwipeDown(){ return null; }
    public final EventHandler<? super SwipeEvent> getOnSwipeLeft(){ return null; }
    public final EventHandler<? super SwipeEvent> getOnSwipeRight(){ return null; }
    public final EventHandler<? super SwipeEvent> getOnSwipeUp(){ return null; }
    public final EventHandler<? super TouchEvent> getOnTouchMoved(){ return null; }
    public final EventHandler<? super TouchEvent> getOnTouchPressed(){ return null; }
    public final EventHandler<? super TouchEvent> getOnTouchReleased(){ return null; }
    public final EventHandler<? super TouchEvent> getOnTouchStationary(){ return null; }
    public final EventHandler<? super ZoomEvent> getOnZoom(){ return null; }
    public final EventHandler<? super ZoomEvent> getOnZoomFinished(){ return null; }
    public final EventHandler<? super ZoomEvent> getOnZoomStarted(){ return null; }
    public final Node getFocusOwner(){ return null; }
    public final NodeOrientation getEffectiveNodeOrientation(){ return null; }
    public final NodeOrientation getNodeOrientation(){ return null; }
    public final ObjectProperty<Camera> cameraProperty(){ return null; }
    public final ObjectProperty<Cursor> cursorProperty(){ return null; }
    public final ObjectProperty<EventDispatcher> eventDispatcherProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super ContextMenuEvent>> onContextMenuRequestedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super DragEvent>> onDragDoneProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super DragEvent>> onDragDroppedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super DragEvent>> onDragEnteredProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super DragEvent>> onDragExitedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super DragEvent>> onDragOverProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super InputMethodEvent>> onInputMethodTextChangedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super KeyEvent>> onKeyPressedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super KeyEvent>> onKeyReleasedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super KeyEvent>> onKeyTypedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super MouseDragEvent>> onMouseDragEnteredProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super MouseDragEvent>> onMouseDragExitedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super MouseDragEvent>> onMouseDragOverProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super MouseDragEvent>> onMouseDragReleasedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super MouseEvent>> onDragDetectedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super MouseEvent>> onMouseClickedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super MouseEvent>> onMouseDraggedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super MouseEvent>> onMouseEnteredProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super MouseEvent>> onMouseExitedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super MouseEvent>> onMouseMovedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super MouseEvent>> onMousePressedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super MouseEvent>> onMouseReleasedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super RotateEvent>> onRotateProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super RotateEvent>> onRotationFinishedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super RotateEvent>> onRotationStartedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super ScrollEvent>> onScrollFinishedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super ScrollEvent>> onScrollProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super ScrollEvent>> onScrollStartedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super SwipeEvent>> onSwipeDownProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super SwipeEvent>> onSwipeLeftProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super SwipeEvent>> onSwipeRightProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super SwipeEvent>> onSwipeUpProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super TouchEvent>> onTouchMovedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super TouchEvent>> onTouchPressedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super TouchEvent>> onTouchReleasedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super TouchEvent>> onTouchStationaryProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super ZoomEvent>> onZoomFinishedProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super ZoomEvent>> onZoomProperty(){ return null; }
    public final ObjectProperty<EventHandler<? super ZoomEvent>> onZoomStartedProperty(){ return null; }
    public final ObjectProperty<NodeOrientation> nodeOrientationProperty(){ return null; }
    public final ObjectProperty<Paint> fillProperty(){ return null; }
    public final ObjectProperty<Parent> rootProperty(){ return null; }
    public final ObjectProperty<String> userAgentStylesheetProperty(){ return null; }
    public final ObservableList<String> getStylesheets(){ return null; }
    public final ObservableMap<Object, Object> getProperties(){ return null; }
    public final Paint getFill(){ return null; }
    public final Parent getRoot(){ return null; }
    public final ReadOnlyDoubleProperty heightProperty(){ return null; }
    public final ReadOnlyDoubleProperty widthProperty(){ return null; }
    public final ReadOnlyDoubleProperty xProperty(){ return null; }
    public final ReadOnlyDoubleProperty yProperty(){ return null; }
    public final ReadOnlyObjectProperty<Node> focusOwnerProperty(){ return null; }
    public final ReadOnlyObjectProperty<NodeOrientation> effectiveNodeOrientationProperty(){ return null; }
    public final ReadOnlyObjectProperty<Window> windowProperty(){ return null; }
    public final SceneAntialiasing getAntiAliasing(){ return null; }
    public final String getUserAgentStylesheet(){ return null; }
    public final Window getWindow(){ return null; }
    public final boolean isDepthBuffer(){ return false; }
    public final double getHeight(){ return 0; }
    public final double getWidth(){ return 0; }
    public final double getX(){ return 0; }
    public final double getY(){ return 0; }
    public final void addPostLayoutPulseListener(Runnable p0){}
    public final void addPreLayoutPulseListener(Runnable p0){}
    public final void removePostLayoutPulseListener(Runnable p0){}
    public final void removePreLayoutPulseListener(Runnable p0){}
    public final void setCamera(Camera p0){}
    public final void setCursor(Cursor p0){}
    public final void setEventDispatcher(EventDispatcher p0){}
    public final void setFill(Paint p0){}
    public final void setNodeOrientation(NodeOrientation p0){}
    public final void setOnContextMenuRequested(EventHandler<? super ContextMenuEvent> p0){}
    public final void setOnDragDetected(EventHandler<? super MouseEvent> p0){}
    public final void setOnDragDone(EventHandler<? super DragEvent> p0){}
    public final void setOnDragDropped(EventHandler<? super DragEvent> p0){}
    public final void setOnDragEntered(EventHandler<? super DragEvent> p0){}
    public final void setOnDragExited(EventHandler<? super DragEvent> p0){}
    public final void setOnDragOver(EventHandler<? super DragEvent> p0){}
    public final void setOnInputMethodTextChanged(EventHandler<? super InputMethodEvent> p0){}
    public final void setOnKeyPressed(EventHandler<? super KeyEvent> p0){}
    public final void setOnKeyReleased(EventHandler<? super KeyEvent> p0){}
    public final void setOnKeyTyped(EventHandler<? super KeyEvent> p0){}
    public final void setOnMouseClicked(EventHandler<? super MouseEvent> p0){}
    public final void setOnMouseDragEntered(EventHandler<? super MouseDragEvent> p0){}
    public final void setOnMouseDragExited(EventHandler<? super MouseDragEvent> p0){}
    public final void setOnMouseDragOver(EventHandler<? super MouseDragEvent> p0){}
    public final void setOnMouseDragReleased(EventHandler<? super MouseDragEvent> p0){}
    public final void setOnMouseDragged(EventHandler<? super MouseEvent> p0){}
    public final void setOnMouseEntered(EventHandler<? super MouseEvent> p0){}
    public final void setOnMouseExited(EventHandler<? super MouseEvent> p0){}
    public final void setOnMouseMoved(EventHandler<? super MouseEvent> p0){}
    public final void setOnMousePressed(EventHandler<? super MouseEvent> p0){}
    public final void setOnMouseReleased(EventHandler<? super MouseEvent> p0){}
    public final void setOnRotate(EventHandler<? super RotateEvent> p0){}
    public final void setOnRotationFinished(EventHandler<? super RotateEvent> p0){}
    public final void setOnRotationStarted(EventHandler<? super RotateEvent> p0){}
    public final void setOnScroll(EventHandler<? super ScrollEvent> p0){}
    public final void setOnScrollFinished(EventHandler<? super ScrollEvent> p0){}
    public final void setOnScrollStarted(EventHandler<? super ScrollEvent> p0){}
    public final void setOnSwipeDown(EventHandler<? super SwipeEvent> p0){}
    public final void setOnSwipeLeft(EventHandler<? super SwipeEvent> p0){}
    public final void setOnSwipeRight(EventHandler<? super SwipeEvent> p0){}
    public final void setOnSwipeUp(EventHandler<? super SwipeEvent> p0){}
    public final void setOnTouchMoved(EventHandler<? super TouchEvent> p0){}
    public final void setOnTouchPressed(EventHandler<? super TouchEvent> p0){}
    public final void setOnTouchReleased(EventHandler<? super TouchEvent> p0){}
    public final void setOnTouchStationary(EventHandler<? super TouchEvent> p0){}
    public final void setOnZoom(EventHandler<? super ZoomEvent> p0){}
    public final void setOnZoomFinished(EventHandler<? super ZoomEvent> p0){}
    public final void setOnZoomStarted(EventHandler<? super ZoomEvent> p0){}
    public final void setRoot(Parent p0){}
    public final void setUserAgentStylesheet(String p0){}
    public void addMnemonic(Mnemonic p0){}
    public void removeMnemonic(Mnemonic p0){}
    public void setUserData(Object p0){}
    public void snapshot(Callback<SnapshotResult, Void> p0, WritableImage p1){}
    public void startFullDrag(){}
}
