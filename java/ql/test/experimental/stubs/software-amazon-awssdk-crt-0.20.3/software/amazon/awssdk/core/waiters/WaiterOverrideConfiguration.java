// Generated automatically from software.amazon.awssdk.core.waiters.WaiterOverrideConfiguration for testing purposes

package software.amazon.awssdk.core.waiters;

import java.time.Duration;
import java.util.Optional;
import software.amazon.awssdk.core.retry.backoff.BackoffStrategy;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class WaiterOverrideConfiguration implements ToCopyableBuilder<WaiterOverrideConfiguration.Builder, WaiterOverrideConfiguration>
{
    protected WaiterOverrideConfiguration() {}
    public Optional<BackoffStrategy> backoffStrategy(){ return null; }
    public Optional<Duration> waitTimeout(){ return null; }
    public Optional<Integer> maxAttempts(){ return null; }
    public String toString(){ return null; }
    public WaiterOverrideConfiguration(WaiterOverrideConfiguration.Builder p0){}
    public WaiterOverrideConfiguration.Builder toBuilder(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static WaiterOverrideConfiguration.Builder builder(){ return null; }
    static public class Builder implements CopyableBuilder<WaiterOverrideConfiguration.Builder, WaiterOverrideConfiguration>
    {
        protected Builder() {}
        public WaiterOverrideConfiguration build(){ return null; }
        public WaiterOverrideConfiguration.Builder backoffStrategy(BackoffStrategy p0){ return null; }
        public WaiterOverrideConfiguration.Builder maxAttempts(Integer p0){ return null; }
        public WaiterOverrideConfiguration.Builder waitTimeout(Duration p0){ return null; }
    }
}
