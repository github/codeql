// Generated automatically from software.amazon.awssdk.utils.builder.SdkBuilder for testing purposes

package software.amazon.awssdk.utils.builder;

import java.util.function.Consumer;
import software.amazon.awssdk.utils.builder.Buildable;

public interface SdkBuilder<B extends SdkBuilder<B, T>, T> extends Buildable
{
    T build();
    default B applyMutation(java.util.function.Consumer<B> p0){ return null; }
}
