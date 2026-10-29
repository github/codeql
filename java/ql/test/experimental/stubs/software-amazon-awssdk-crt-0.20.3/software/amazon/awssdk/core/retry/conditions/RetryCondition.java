// Generated automatically from software.amazon.awssdk.core.retry.conditions.RetryCondition for testing purposes

package software.amazon.awssdk.core.retry.conditions;

import software.amazon.awssdk.core.retry.RetryPolicyContext;

public interface RetryCondition
{
    boolean shouldRetry(RetryPolicyContext p0);
    default void requestSucceeded(RetryPolicyContext p0){}
    default void requestWillNotBeRetried(RetryPolicyContext p0){}
    static RetryCondition defaultRetryCondition(){ return null; }
    static RetryCondition none(){ return null; }
}
