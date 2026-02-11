// Generated automatically from software.amazon.awssdk.core.retry.backoff.BackoffStrategy for testing purposes

package software.amazon.awssdk.core.retry.backoff;

import java.time.Duration;
import software.amazon.awssdk.core.retry.RetryMode;
import software.amazon.awssdk.core.retry.RetryPolicyContext;

public interface BackoffStrategy
{
    Duration computeDelayBeforeNextRetry(RetryPolicyContext p0);
    default int calculateExponentialDelay(int p0, Duration p1, Duration p2){ return 0; }
    static BackoffStrategy defaultStrategy(){ return null; }
    static BackoffStrategy defaultStrategy(RetryMode p0){ return null; }
    static BackoffStrategy defaultThrottlingStrategy(){ return null; }
    static BackoffStrategy defaultThrottlingStrategy(RetryMode p0){ return null; }
    static BackoffStrategy none(){ return null; }
    static int RETRIES_ATTEMPTED_CEILING = 0;
}
