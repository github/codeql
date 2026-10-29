// Generated automatically from reactor.core.Disposable for testing purposes

package reactor.core;


public interface Disposable
{
    default boolean isDisposed(){ return false; }
    void dispose();
}
