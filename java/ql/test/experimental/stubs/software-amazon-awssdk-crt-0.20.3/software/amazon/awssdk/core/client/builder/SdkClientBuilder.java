// Generated automatically from software.amazon.awssdk.core.client.builder.SdkClientBuilder for testing purposes

package software.amazon.awssdk.core.client.builder;

import java.net.URI;
import java.util.function.Consumer;
import software.amazon.awssdk.core.client.config.ClientOverrideConfiguration;
import software.amazon.awssdk.utils.builder.SdkBuilder;

public interface SdkClientBuilder<B extends SdkClientBuilder<B, C>, C> extends software.amazon.awssdk.utils.builder.SdkBuilder<B, C>
{
    B endpointOverride(URI p0);
    B overrideConfiguration(ClientOverrideConfiguration p0);
    ClientOverrideConfiguration overrideConfiguration();
    default B overrideConfiguration(java.util.function.Consumer<ClientOverrideConfiguration.Builder> p0){ return null; }
}
