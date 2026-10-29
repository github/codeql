// Generated automatically from javafx.scene.Node for testing purposes

package javafx.scene;

import java.util.List;
import java.util.Set;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.DoubleProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.ReadOnlyBooleanProperty;
import javafx.beans.property.ReadOnlyBooleanPropertyBase;
import javafx.beans.property.ReadOnlyObjectProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.ObservableList;
import javafx.collections.ObservableMap;
import javafx.collections.ObservableSet;
import javafx.css.CssMetaData;
import javafx.css.PseudoClass;
import javafx.css.Styleable;
import javafx.event.Event;
import javafx.event.EventDispatchChain;
import javafx.event.EventDispatcher;
import javafx.event.EventHandler;
import javafx.event.EventTarget;
import javafx.event.EventType;
import javafx.geometry.Bounds;
import javafx.geometry.NodeOrientation;
import javafx.geometry.Orientation;
import javafx.geometry.Point2D;
import javafx.geometry.Point3D;
import javafx.scene.AccessibleAction;
import javafx.scene.AccessibleAttribute;
import javafx.scene.AccessibleRole;
import javafx.scene.CacheHint;
import javafx.scene.Cursor;
import javafx.scene.DepthTest;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.SnapshotParameters;
import javafx.scene.SnapshotResult;
import javafx.scene.effect.BlendMode;
import javafx.scene.effect.Effect;
import javafx.scene.image.WritableImage;
import javafx.scene.input.ContextMenuEvent;
import javafx.scene.input.DragEvent;
import javafx.scene.input.Dragboard;
import javafx.scene.input.InputMethodEvent;
import javafx.scene.input.InputMethodRequests;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.MouseDragEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.RotateEvent;
import javafx.scene.input.ScrollEvent;
import javafx.scene.input.SwipeEvent;
import javafx.scene.input.TouchEvent;
import javafx.scene.input.TransferMode;
import javafx.scene.input.ZoomEvent;
import javafx.scene.transform.Transform;
import javafx.util.Callback;

abstract public class Node implements EventTarget, Styleable
{
    protected Boolean getInitialFocusTraversable(){ return null; }
    protected Cursor getInitialCursor(){ return null; }
    protected Node(){}
    protected final <T extends Event> void setEventHandler(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    protected final void setDisabled(boolean p0){}
    protected final void setFocused(boolean p0){}
    protected final void setHover(boolean p0){}
    protected final void setPressed(boolean p0){}
    public Bounds localToParent(Bounds p0){ return null; }
    public Bounds localToScene(Bounds p0){ return null; }
    public Bounds localToScene(Bounds p0, boolean p1){ return null; }
    public Bounds localToScreen(Bounds p0){ return null; }
    public Bounds parentToLocal(Bounds p0){ return null; }
    public Bounds sceneToLocal(Bounds p0){ return null; }
    public Bounds sceneToLocal(Bounds p0, boolean p1){ return null; }
    public Bounds screenToLocal(Bounds p0){ return null; }
    public Dragboard startDragAndDrop(TransferMode... p0){ return null; }
    public EventDispatchChain buildEventDispatchChain(EventDispatchChain p0){ return null; }
    public List<CssMetaData<? extends Styleable, ? extends Object>> getCssMetaData(){ return null; }
    public Node lookup(String p0){ return null; }
    public Object getUserData(){ return null; }
    public Object queryAccessibleAttribute(AccessibleAttribute p0, Object... p1){ return null; }
    public Orientation getContentBias(){ return null; }
    public Point2D localToParent(Point2D p0){ return null; }
    public Point2D localToParent(double p0, double p1){ return null; }
    public Point2D localToScene(Point2D p0){ return null; }
    public Point2D localToScene(Point2D p0, boolean p1){ return null; }
    public Point2D localToScene(double p0, double p1){ return null; }
    public Point2D localToScene(double p0, double p1, boolean p2){ return null; }
    public Point2D localToScreen(Point2D p0){ return null; }
    public Point2D localToScreen(Point3D p0){ return null; }
    public Point2D localToScreen(double p0, double p1){ return null; }
    public Point2D localToScreen(double p0, double p1, double p2){ return null; }
    public Point2D parentToLocal(Point2D p0){ return null; }
    public Point2D parentToLocal(double p0, double p1){ return null; }
    public Point2D sceneToLocal(Point2D p0){ return null; }
    public Point2D sceneToLocal(Point2D p0, boolean p1){ return null; }
    public Point2D sceneToLocal(double p0, double p1){ return null; }
    public Point2D sceneToLocal(double p0, double p1, boolean p2){ return null; }
    public Point2D screenToLocal(Point2D p0){ return null; }
    public Point2D screenToLocal(double p0, double p1){ return null; }
    public Point3D localToParent(Point3D p0){ return null; }
    public Point3D localToParent(double p0, double p1, double p2){ return null; }
    public Point3D localToScene(Point3D p0){ return null; }
    public Point3D localToScene(Point3D p0, boolean p1){ return null; }
    public Point3D localToScene(double p0, double p1, double p2){ return null; }
    public Point3D localToScene(double p0, double p1, double p2, boolean p3){ return null; }
    public Point3D parentToLocal(Point3D p0){ return null; }
    public Point3D parentToLocal(double p0, double p1, double p2){ return null; }
    public Point3D sceneToLocal(Point3D p0){ return null; }
    public Point3D sceneToLocal(double p0, double p1, double p2){ return null; }
    public Set<Node> lookupAll(String p0){ return null; }
    public String getTypeSelector(){ return null; }
    public String toString(){ return null; }
    public Styleable getStyleableParent(){ return null; }
    public WritableImage snapshot(SnapshotParameters p0, WritableImage p1){ return null; }
    public boolean contains(Point2D p0){ return false; }
    public boolean contains(double p0, double p1){ return false; }
    public boolean hasProperties(){ return false; }
    public boolean intersects(Bounds p0){ return false; }
    public boolean intersects(double p0, double p1, double p2, double p3){ return false; }
    public boolean isResizable(){ return false; }
    public boolean usesMirroring(){ return false; }
    public double computeAreaInScreen(){ return 0; }
    public double getBaselineOffset(){ return 0; }
    public double maxHeight(double p0){ return 0; }
    public double maxWidth(double p0){ return 0; }
    public double minHeight(double p0){ return 0; }
    public double minWidth(double p0){ return 0; }
    public double prefHeight(double p0){ return 0; }
    public double prefWidth(double p0){ return 0; }
    public final <T extends Event> void addEventFilter(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final <T extends Event> void addEventHandler(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final <T extends Event> void removeEventFilter(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final <T extends Event> void removeEventHandler(javafx.event.EventType<T> p0, javafx.event.EventHandler<? super T> p1){}
    public final AccessibleRole getAccessibleRole(){ return null; }
    public final BlendMode getBlendMode(){ return null; }
    public final BooleanProperty cacheProperty(){ return null; }
    public final BooleanProperty disableProperty(){ return null; }
    public final BooleanProperty focusTraversableProperty(){ return null; }
    public final BooleanProperty managedProperty(){ return null; }
    public final BooleanProperty mouseTransparentProperty(){ return null; }
    public final BooleanProperty pickOnBoundsProperty(){ return null; }
    public final BooleanProperty visibleProperty(){ return null; }
    public final Bounds getBoundsInLocal(){ return null; }
    public final Bounds getBoundsInParent(){ return null; }
    public final Bounds getLayoutBounds(){ return null; }
    public final CacheHint getCacheHint(){ return null; }
    public final Cursor getCursor(){ return null; }
    public final DepthTest getDepthTest(){ return null; }
    public final DoubleProperty layoutXProperty(){ return null; }
    public final DoubleProperty layoutYProperty(){ return null; }
    public final DoubleProperty opacityProperty(){ return null; }
    public final DoubleProperty rotateProperty(){ return null; }
    public final DoubleProperty scaleXProperty(){ return null; }
    public final DoubleProperty scaleYProperty(){ return null; }
    public final DoubleProperty scaleZProperty(){ return null; }
    public final DoubleProperty translateXProperty(){ return null; }
    public final DoubleProperty translateYProperty(){ return null; }
    public final DoubleProperty translateZProperty(){ return null; }
    public final DoubleProperty viewOrderProperty(){ return null; }
    public final Effect getEffect(){ return null; }
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
    public final InputMethodRequests getInputMethodRequests(){ return null; }
    public final Node getClip(){ return null; }
    public final NodeOrientation getEffectiveNodeOrientation(){ return null; }
    public final NodeOrientation getNodeOrientation(){ return null; }
    public final ObjectProperty<AccessibleRole> accessibleRoleProperty(){ return null; }
    public final ObjectProperty<BlendMode> blendModeProperty(){ return null; }
    public final ObjectProperty<CacheHint> cacheHintProperty(){ return null; }
    public final ObjectProperty<Cursor> cursorProperty(){ return null; }
    public final ObjectProperty<DepthTest> depthTestProperty(){ return null; }
    public final ObjectProperty<Effect> effectProperty(){ return null; }
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
    public final ObjectProperty<InputMethodRequests> inputMethodRequestsProperty(){ return null; }
    public final ObjectProperty<Node> clipProperty(){ return null; }
    public final ObjectProperty<NodeOrientation> nodeOrientationProperty(){ return null; }
    public final ObjectProperty<Point3D> rotationAxisProperty(){ return null; }
    public final ObjectProperty<String> accessibleHelpProperty(){ return null; }
    public final ObjectProperty<String> accessibleRoleDescriptionProperty(){ return null; }
    public final ObjectProperty<String> accessibleTextProperty(){ return null; }
    public final ObservableList<String> getStyleClass(){ return null; }
    public final ObservableList<Transform> getTransforms(){ return null; }
    public final ObservableMap<Object, Object> getProperties(){ return null; }
    public final ObservableSet<PseudoClass> getPseudoClassStates(){ return null; }
    public final Parent getParent(){ return null; }
    public final Point3D getRotationAxis(){ return null; }
    public final ReadOnlyBooleanProperty disabledProperty(){ return null; }
    public final ReadOnlyBooleanProperty focusVisibleProperty(){ return null; }
    public final ReadOnlyBooleanProperty focusWithinProperty(){ return null; }
    public final ReadOnlyBooleanProperty focusedProperty(){ return null; }
    public final ReadOnlyBooleanProperty hoverProperty(){ return null; }
    public final ReadOnlyBooleanProperty pressedProperty(){ return null; }
    public final ReadOnlyObjectProperty<Bounds> boundsInLocalProperty(){ return null; }
    public final ReadOnlyObjectProperty<Bounds> boundsInParentProperty(){ return null; }
    public final ReadOnlyObjectProperty<Bounds> layoutBoundsProperty(){ return null; }
    public final ReadOnlyObjectProperty<NodeOrientation> effectiveNodeOrientationProperty(){ return null; }
    public final ReadOnlyObjectProperty<Parent> parentProperty(){ return null; }
    public final ReadOnlyObjectProperty<Scene> sceneProperty(){ return null; }
    public final ReadOnlyObjectProperty<Transform> localToParentTransformProperty(){ return null; }
    public final ReadOnlyObjectProperty<Transform> localToSceneTransformProperty(){ return null; }
    public final Scene getScene(){ return null; }
    public final String getAccessibleHelp(){ return null; }
    public final String getAccessibleRoleDescription(){ return null; }
    public final String getAccessibleText(){ return null; }
    public final String getId(){ return null; }
    public final String getStyle(){ return null; }
    public final StringProperty idProperty(){ return null; }
    public final StringProperty styleProperty(){ return null; }
    public final Transform getLocalToParentTransform(){ return null; }
    public final Transform getLocalToSceneTransform(){ return null; }
    public final boolean isCache(){ return false; }
    public final boolean isDisable(){ return false; }
    public final boolean isDisabled(){ return false; }
    public final boolean isFocusTraversable(){ return false; }
    public final boolean isFocusVisible(){ return false; }
    public final boolean isFocusWithin(){ return false; }
    public final boolean isFocused(){ return false; }
    public final boolean isHover(){ return false; }
    public final boolean isManaged(){ return false; }
    public final boolean isMouseTransparent(){ return false; }
    public final boolean isPickOnBounds(){ return false; }
    public final boolean isPressed(){ return false; }
    public final boolean isVisible(){ return false; }
    public final double getLayoutX(){ return 0; }
    public final double getLayoutY(){ return 0; }
    public final double getOpacity(){ return 0; }
    public final double getRotate(){ return 0; }
    public final double getScaleX(){ return 0; }
    public final double getScaleY(){ return 0; }
    public final double getScaleZ(){ return 0; }
    public final double getTranslateX(){ return 0; }
    public final double getTranslateY(){ return 0; }
    public final double getTranslateZ(){ return 0; }
    public final double getViewOrder(){ return 0; }
    public final void applyCss(){}
    public final void autosize(){}
    public final void fireEvent(Event p0){}
    public final void notifyAccessibleAttributeChanged(AccessibleAttribute p0){}
    public final void pseudoClassStateChanged(PseudoClass p0, boolean p1){}
    public final void setAccessibleHelp(String p0){}
    public final void setAccessibleRole(AccessibleRole p0){}
    public final void setAccessibleRoleDescription(String p0){}
    public final void setAccessibleText(String p0){}
    public final void setBlendMode(BlendMode p0){}
    public final void setCache(boolean p0){}
    public final void setCacheHint(CacheHint p0){}
    public final void setClip(Node p0){}
    public final void setCursor(Cursor p0){}
    public final void setDepthTest(DepthTest p0){}
    public final void setDisable(boolean p0){}
    public final void setEffect(Effect p0){}
    public final void setEventDispatcher(EventDispatcher p0){}
    public final void setFocusTraversable(boolean p0){}
    public final void setId(String p0){}
    public final void setInputMethodRequests(InputMethodRequests p0){}
    public final void setLayoutX(double p0){}
    public final void setLayoutY(double p0){}
    public final void setManaged(boolean p0){}
    public final void setMouseTransparent(boolean p0){}
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
    public final void setOpacity(double p0){}
    public final void setPickOnBounds(boolean p0){}
    public final void setRotate(double p0){}
    public final void setRotationAxis(Point3D p0){}
    public final void setScaleX(double p0){}
    public final void setScaleY(double p0){}
    public final void setScaleZ(double p0){}
    public final void setStyle(String p0){}
    public final void setTranslateX(double p0){}
    public final void setTranslateY(double p0){}
    public final void setTranslateZ(double p0){}
    public final void setViewOrder(double p0){}
    public final void setVisible(boolean p0){}
    public static List<CssMetaData<? extends Styleable, ? extends Object>> getClassCssMetaData(){ return null; }
    public static double BASELINE_OFFSET_SAME_AS_HEIGHT = 0;
    public void executeAccessibleAction(AccessibleAction p0, Object... p1){}
    public void relocate(double p0, double p1){}
    public void requestFocus(){}
    public void resize(double p0, double p1){}
    public void resizeRelocate(double p0, double p1, double p2, double p3){}
    public void setUserData(Object p0){}
    public void snapshot(Callback<SnapshotResult, Void> p0, SnapshotParameters p1, WritableImage p2){}
    public void startFullDrag(){}
    public void toBack(){}
    public void toFront(){}
}
