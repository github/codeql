// Generated automatically from reactor.core.observability.SignalListenerFactory for testing purposes

package reactor.core.observability;

import org.reactivestreams.Publisher;
import reactor.core.observability.SignalListener;
import reactor.util.context.ContextView;

public interface SignalListenerFactory<T, STATE>
{
    STATE initializePublisherState(org.reactivestreams.Publisher<? extends T> p0);
    reactor.core.observability.SignalListener<T> createListener(org.reactivestreams.Publisher<? extends T> p0, ContextView p1, STATE p2);
}
