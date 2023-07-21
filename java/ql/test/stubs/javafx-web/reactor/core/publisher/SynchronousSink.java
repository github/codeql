// Generated automatically from reactor.core.publisher.SynchronousSink for testing purposes

package reactor.core.publisher;

import reactor.util.context.Context;
import reactor.util.context.ContextView;

public interface SynchronousSink<T>
{
    Context currentContext();
    default ContextView contextView(){ return null; }
    void complete();
    void error(Throwable p0);
    void next(T p0);
}
