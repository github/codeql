// Generated automatically from reactor.core.CoreSubscriber for testing purposes

package reactor.core;

import org.reactivestreams.Subscriber;
import org.reactivestreams.Subscription;
import reactor.util.context.Context;

public interface CoreSubscriber<T> extends org.reactivestreams.Subscriber<T>
{
    default Context currentContext(){ return null; }
    void onSubscribe(Subscription p0);
}
