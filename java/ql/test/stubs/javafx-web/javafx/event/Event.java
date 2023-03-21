// Generated automatically from javafx.event.Event for testing purposes

package javafx.event;

import java.util.EventObject;
import javafx.event.EventTarget;
import javafx.event.EventType;

public class Event extends EventObject implements Cloneable {
    protected Event() {
        super(null);
    }

    protected EventTarget target = null;
    protected EventType<? extends Event> eventType = null;
    protected boolean consumed = false;

    public Event copyFor(Object p0, EventTarget p1) {
        return null;
    }

    public Event(EventType<? extends Event> p0) {
        super(p0);
    }

    public Event(Object p0, EventTarget p1, EventType<? extends Event> p2) {
        super(p0);
    }

    public EventTarget getTarget() {
        return null;
    }

    public EventType<? extends Event> getEventType() {
        return null;
    }

    public Object clone() {
        return null;
    }

    public boolean isConsumed() {
        return false;
    }

    public static EventTarget NULL_SOURCE_TARGET = null;
    public static EventType<Event> ANY = null;

    public static void fireEvent(EventTarget p0, Event p1) {}

    public void consume() {}
}
