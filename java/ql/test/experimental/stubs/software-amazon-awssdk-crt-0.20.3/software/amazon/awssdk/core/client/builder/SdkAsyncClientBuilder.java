// Generated automatically from software.amazon.awssdk.core.client.builder.SdkAsyncClientBuilder for testing purposes

package software.amazon.awssdk.core.client.builder;

import java.util.function.Consumer;
import software.amazon.awssdk.core.client.config.ClientAsyncConfiguration;
import software.amazon.awssdk.http.async.SdkAsyncHttpClient;

public interface SdkAsyncClientBuilder<B extends SdkAsyncClientBuilder<B, C>, C>
{
    B asyncConfiguration(ClientAsyncConfiguration p0);
    B httpClient(SdkAsyncHttpClient p0);
    B httpClientBuilder(SdkAsyncHttpClient.Builder p0);
    default B asyncConfiguration(java.util.function.Consumer<ClientAsyncConfiguration.Builder> p0){ return null; }
}
