// Generated automatically from javafx.event.EventDispatchChain for testing purposes

package javafx.event;

import javafx.event.Event;
import javafx.event.EventDispatcher;

public interface EventDispatchChain
{
    Event dispatchEvent(Event p0);
    EventDispatchChain append(EventDispatcher p0);
    EventDispatchChain prepend(EventDispatcher p0);
}
