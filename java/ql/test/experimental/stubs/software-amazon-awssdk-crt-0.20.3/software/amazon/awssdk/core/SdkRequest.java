// Generated automatically from software.amazon.awssdk.core.SdkRequest for testing purposes

package software.amazon.awssdk.core;

import java.util.Optional;
import software.amazon.awssdk.core.RequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkPojo;

abstract public class SdkRequest implements SdkPojo
{
    public <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public SdkRequest(){}
    public abstract Optional<? extends RequestOverrideConfiguration> overrideConfiguration();
    public abstract SdkRequest.Builder toBuilder();
    static public interface Builder
    {
        RequestOverrideConfiguration overrideConfiguration();
        SdkRequest build();
    }
}
