// Generated automatically from javafx.scene.input.TouchPoint for testing purposes

package javafx.scene.input;

import java.io.Serializable;
import javafx.event.EventTarget;
import javafx.scene.input.PickResult;

public class TouchPoint implements Serializable
{
    protected TouchPoint() {}
    public EventTarget getGrabbed(){ return null; }
    public EventTarget getTarget(){ return null; }
    public String toString(){ return null; }
    public TouchPoint(int p0, TouchPoint.State p1, double p2, double p3, double p4, double p5, EventTarget p6, PickResult p7){}
    public boolean belongsTo(EventTarget p0){ return false; }
    public final PickResult getPickResult(){ return null; }
    public final TouchPoint.State getState(){ return null; }
    public final double getSceneX(){ return 0; }
    public final double getSceneY(){ return 0; }
    public final double getScreenX(){ return 0; }
    public final double getScreenY(){ return 0; }
    public final double getX(){ return 0; }
    public final double getY(){ return 0; }
    public final double getZ(){ return 0; }
    public final int getId(){ return 0; }
    public void grab(){}
    public void grab(EventTarget p0){}
    public void ungrab(){}
    static public enum State
    {
        MOVED, PRESSED, RELEASED, STATIONARY;
        private State() {}
    }
}
