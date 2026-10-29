// Generated automatically from javafx.scene.input.DragEvent for testing purposes

package javafx.scene.input;

import javafx.event.Event;
import javafx.event.EventTarget;
import javafx.event.EventType;
import javafx.scene.input.Dragboard;
import javafx.scene.input.InputEvent;
import javafx.scene.input.PickResult;
import javafx.scene.input.TransferMode;

public class DragEvent extends InputEvent
{
    protected DragEvent() {}
    public DragEvent copyFor(Object p0, EventTarget p1){ return null; }
    public DragEvent copyFor(Object p0, EventTarget p1, EventType<DragEvent> p2){ return null; }
    public DragEvent copyFor(Object p0, EventTarget p1, Object p2, Object p3, EventType<DragEvent> p4){ return null; }
    public DragEvent(EventType<DragEvent> p0, Dragboard p1, double p2, double p3, double p4, double p5, TransferMode p6, Object p7, Object p8, PickResult p9){}
    public DragEvent(Object p0, EventTarget p1, EventType<DragEvent> p2, Dragboard p3, double p4, double p5, double p6, double p7, TransferMode p8, Object p9, Object p10, PickResult p11){}
    public EventType<DragEvent> getEventType(){ return null; }
    public boolean isDropCompleted(){ return false; }
    public final Dragboard getDragboard(){ return null; }
    public final Object getAcceptingObject(){ return null; }
    public final Object getGestureSource(){ return null; }
    public final Object getGestureTarget(){ return null; }
    public final PickResult getPickResult(){ return null; }
    public final TransferMode getAcceptedTransferMode(){ return null; }
    public final TransferMode getTransferMode(){ return null; }
    public final boolean isAccepted(){ return false; }
    public final double getSceneX(){ return 0; }
    public final double getSceneY(){ return 0; }
    public final double getScreenX(){ return 0; }
    public final double getScreenY(){ return 0; }
    public final double getX(){ return 0; }
    public final double getY(){ return 0; }
    public final double getZ(){ return 0; }
    public static EventType<DragEvent> ANY = null;
    public static EventType<DragEvent> DRAG_DONE = null;
    public static EventType<DragEvent> DRAG_DROPPED = null;
    public static EventType<DragEvent> DRAG_ENTERED = null;
    public static EventType<DragEvent> DRAG_ENTERED_TARGET = null;
    public static EventType<DragEvent> DRAG_EXITED = null;
    public static EventType<DragEvent> DRAG_EXITED_TARGET = null;
    public static EventType<DragEvent> DRAG_OVER = null;
    public void acceptTransferModes(TransferMode... p0){}
    public void setDropCompleted(boolean p0){}
}
