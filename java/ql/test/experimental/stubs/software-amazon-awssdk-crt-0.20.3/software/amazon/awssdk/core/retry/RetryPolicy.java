// Generated automatically from software.amazon.awssdk.core.retry.RetryPolicy for testing purposes

package software.amazon.awssdk.core.retry;

import software.amazon.awssdk.core.retry.RetryMode;
import software.amazon.awssdk.core.retry.backoff.BackoffStrategy;
import software.amazon.awssdk.core.retry.conditions.RetryCondition;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class RetryPolicy implements ToCopyableBuilder<RetryPolicy.Builder, RetryPolicy>
{
    protected RetryPolicy() {}
    public BackoffStrategy backoffStrategy(){ return null; }
    public BackoffStrategy throttlingBackoffStrategy(){ return null; }
    public Boolean isFastFailRateLimiting(){ return null; }
    public Integer numRetries(){ return null; }
    public RetryCondition aggregateRetryCondition(){ return null; }
    public RetryCondition retryCondition(){ return null; }
    public RetryMode retryMode(){ return null; }
    public RetryPolicy.Builder toBuilder(){ return null; }
    public String toString(){ return null; }
    public boolean additionalRetryConditionsAllowed(){ return false; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static RetryPolicy defaultRetryPolicy(){ return null; }
    public static RetryPolicy forRetryMode(RetryMode p0){ return null; }
    public static RetryPolicy none(){ return null; }
    public static RetryPolicy.Builder builder(){ return null; }
    public static RetryPolicy.Builder builder(RetryMode p0){ return null; }
    static public interface Builder extends CopyableBuilder<RetryPolicy.Builder, RetryPolicy>
    {
        BackoffStrategy backoffStrategy();
        BackoffStrategy throttlingBackoffStrategy();
        Boolean isFastFailRateLimiting();
        Integer numRetries();
        RetryCondition retryCapacityCondition();
        RetryCondition retryCondition();
        RetryPolicy build();
        RetryPolicy.Builder additionalRetryConditionsAllowed(boolean p0);
        RetryPolicy.Builder backoffStrategy(BackoffStrategy p0);
        RetryPolicy.Builder fastFailRateLimiting(Boolean p0);
        RetryPolicy.Builder numRetries(Integer p0);
        RetryPolicy.Builder retryCapacityCondition(RetryCondition p0);
        RetryPolicy.Builder retryCondition(RetryCondition p0);
        RetryPolicy.Builder throttlingBackoffStrategy(BackoffStrategy p0);
        boolean additionalRetryConditionsAllowed();
    }
}
