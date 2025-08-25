// Generated automatically from org.reactivestreams.Subscriber for testing purposes

package org.reactivestreams;

import org.reactivestreams.Subscription;

public interface Subscriber<T>
{
    void onComplete();
    void onError(Throwable p0);
    void onNext(T p0);
    void onSubscribe(Subscription p0);
}
