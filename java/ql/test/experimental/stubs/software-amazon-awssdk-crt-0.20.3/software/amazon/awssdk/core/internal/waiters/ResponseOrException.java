// Generated automatically from software.amazon.awssdk.core.internal.waiters.ResponseOrException for testing purposes

package software.amazon.awssdk.core.internal.waiters;

import java.util.Optional;

public class ResponseOrException<R>
{
    protected ResponseOrException() {}
    public Optional<R> response(){ return null; }
    public Optional<Throwable> exception(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static <R> software.amazon.awssdk.core.internal.waiters.ResponseOrException<R> exception(Throwable p0){ return null; }
    public static <R> software.amazon.awssdk.core.internal.waiters.ResponseOrException<R> response(R p0){ return null; }
}
