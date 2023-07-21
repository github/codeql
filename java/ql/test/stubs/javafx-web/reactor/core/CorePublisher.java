// Generated automatically from reactor.core.CorePublisher for testing purposes

package reactor.core;

import org.reactivestreams.Publisher;
import reactor.core.CoreSubscriber;

public interface CorePublisher<T> extends org.reactivestreams.Publisher<T>
{
    void subscribe(reactor.core.CoreSubscriber<? super T> p0);
}
