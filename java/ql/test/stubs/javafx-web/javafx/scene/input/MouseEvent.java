// Generated automatically from javafx.scene.input.MouseEvent for testing purposes

package javafx.scene.input;

import javafx.event.Event;
import javafx.event.EventTarget;
import javafx.event.EventType;
import javafx.scene.input.InputEvent;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseDragEvent;
import javafx.scene.input.PickResult;

public class MouseEvent extends InputEvent
{
    protected MouseEvent() {}
    public EventType<? extends MouseEvent> getEventType(){ return null; }
    public MouseEvent copyFor(Object p0, EventTarget p1){ return null; }
    public MouseEvent copyFor(Object p0, EventTarget p1, EventType<? extends MouseEvent> p2){ return null; }
    public MouseEvent(EventType<? extends MouseEvent> p0, double p1, double p2, double p3, double p4, MouseButton p5, int p6, boolean p7, boolean p8, boolean p9, boolean p10, boolean p11, boolean p12, boolean p13, boolean p14, boolean p15, boolean p16, PickResult p17){}
    public MouseEvent(EventType<? extends MouseEvent> p0, double p1, double p2, double p3, double p4, MouseButton p5, int p6, boolean p7, boolean p8, boolean p9, boolean p10, boolean p11, boolean p12, boolean p13, boolean p14, boolean p15, boolean p16, boolean p17, boolean p18, PickResult p19){}
    public MouseEvent(Object p0, EventTarget p1, EventType<? extends MouseEvent> p2, double p3, double p4, double p5, double p6, MouseButton p7, int p8, boolean p9, boolean p10, boolean p11, boolean p12, boolean p13, boolean p14, boolean p15, boolean p16, boolean p17, boolean p18, PickResult p19){}
    public MouseEvent(Object p0, EventTarget p1, EventType<? extends MouseEvent> p2, double p3, double p4, double p5, double p6, MouseButton p7, int p8, boolean p9, boolean p10, boolean p11, boolean p12, boolean p13, boolean p14, boolean p15, boolean p16, boolean p17, boolean p18, boolean p19, boolean p20, PickResult p21){}
    public String toString(){ return null; }
    public boolean isDragDetect(){ return false; }
    public boolean isSynthesized(){ return false; }
    public final MouseButton getButton(){ return null; }
    public final PickResult getPickResult(){ return null; }
    public final boolean isAltDown(){ return false; }
    public final boolean isBackButtonDown(){ return false; }
    public final boolean isControlDown(){ return false; }
    public final boolean isForwardButtonDown(){ return false; }
    public final boolean isMetaDown(){ return false; }
    public final boolean isMiddleButtonDown(){ return false; }
    public final boolean isPopupTrigger(){ return false; }
    public final boolean isPrimaryButtonDown(){ return false; }
    public final boolean isSecondaryButtonDown(){ return false; }
    public final boolean isShiftDown(){ return false; }
    public final boolean isShortcutDown(){ return false; }
    public final boolean isStillSincePress(){ return false; }
    public final double getSceneX(){ return 0; }
    public final double getSceneY(){ return 0; }
    public final double getScreenX(){ return 0; }
    public final double getScreenY(){ return 0; }
    public final double getX(){ return 0; }
    public final double getY(){ return 0; }
    public final double getZ(){ return 0; }
    public final int getClickCount(){ return 0; }
    public static EventType<MouseEvent> ANY = null;
    public static EventType<MouseEvent> DRAG_DETECTED = null;
    public static EventType<MouseEvent> MOUSE_CLICKED = null;
    public static EventType<MouseEvent> MOUSE_DRAGGED = null;
    public static EventType<MouseEvent> MOUSE_ENTERED = null;
    public static EventType<MouseEvent> MOUSE_ENTERED_TARGET = null;
    public static EventType<MouseEvent> MOUSE_EXITED = null;
    public static EventType<MouseEvent> MOUSE_EXITED_TARGET = null;
    public static EventType<MouseEvent> MOUSE_MOVED = null;
    public static EventType<MouseEvent> MOUSE_PRESSED = null;
    public static EventType<MouseEvent> MOUSE_RELEASED = null;
    public static MouseDragEvent copyForMouseDragEvent(MouseEvent p0, Object p1, EventTarget p2, EventType<MouseDragEvent> p3, Object p4, PickResult p5){ return null; }
    public void setDragDetect(boolean p0){}
}
