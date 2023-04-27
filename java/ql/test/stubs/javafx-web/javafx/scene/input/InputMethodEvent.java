// Generated automatically from javafx.scene.input.InputMethodEvent for testing purposes

package javafx.scene.input;

import java.util.List;
import javafx.collections.ObservableList;
import javafx.event.Event;
import javafx.event.EventTarget;
import javafx.event.EventType;
import javafx.scene.input.InputEvent;
import javafx.scene.input.InputMethodTextRun;

public class InputMethodEvent extends InputEvent
{
    protected InputMethodEvent() {}
    public EventType<InputMethodEvent> getEventType(){ return null; }
    public InputMethodEvent copyFor(Object p0, EventTarget p1){ return null; }
    public InputMethodEvent(EventType<InputMethodEvent> p0, List<InputMethodTextRun> p1, String p2, int p3){}
    public InputMethodEvent(Object p0, EventTarget p1, EventType<InputMethodEvent> p2, List<InputMethodTextRun> p3, String p4, int p5){}
    public String toString(){ return null; }
    public final ObservableList<InputMethodTextRun> getComposed(){ return null; }
    public final String getCommitted(){ return null; }
    public final int getCaretPosition(){ return 0; }
    public static EventType<InputMethodEvent> ANY = null;
    public static EventType<InputMethodEvent> INPUT_METHOD_TEXT_CHANGED = null;
}
