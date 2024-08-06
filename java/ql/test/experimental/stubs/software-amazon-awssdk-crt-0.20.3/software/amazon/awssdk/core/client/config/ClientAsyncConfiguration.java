// Generated automatically from software.amazon.awssdk.core.client.config.ClientAsyncConfiguration for testing purposes

package software.amazon.awssdk.core.client.config;

import java.util.Map;
import software.amazon.awssdk.core.client.config.SdkAdvancedAsyncClientOption;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ClientAsyncConfiguration implements ToCopyableBuilder<ClientAsyncConfiguration.Builder, ClientAsyncConfiguration>
{
    protected ClientAsyncConfiguration() {}
    public <T> T advancedOption(software.amazon.awssdk.core.client.config.SdkAdvancedAsyncClientOption<T> p0){ return null; }
    public ClientAsyncConfiguration.Builder toBuilder(){ return null; }
    public static ClientAsyncConfiguration.Builder builder(){ return null; }
    static public interface Builder extends CopyableBuilder<ClientAsyncConfiguration.Builder, ClientAsyncConfiguration>
    {
        <T> ClientAsyncConfiguration.Builder advancedOption(software.amazon.awssdk.core.client.config.SdkAdvancedAsyncClientOption<T> p0, T p1);
        ClientAsyncConfiguration.Builder advancedOptions(Map<SdkAdvancedAsyncClientOption<? extends Object>, ? extends Object> p0);
    }
}
