// Generated automatically from software.amazon.awssdk.core.waiters.WaiterResponse for testing purposes

package software.amazon.awssdk.core.waiters;

import software.amazon.awssdk.core.internal.waiters.ResponseOrException;

public interface WaiterResponse<T>
{
    ResponseOrException<T> matched();
    int attemptsExecuted();
}
