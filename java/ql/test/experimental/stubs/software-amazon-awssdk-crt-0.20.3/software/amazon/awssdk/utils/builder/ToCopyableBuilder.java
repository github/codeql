// Generated automatically from software.amazon.awssdk.utils.builder.ToCopyableBuilder for testing purposes

package software.amazon.awssdk.utils.builder;

import java.util.function.Consumer;
import software.amazon.awssdk.utils.builder.CopyableBuilder;

public interface ToCopyableBuilder<B extends CopyableBuilder<B, T>, T extends ToCopyableBuilder<B, T>>
{
    B toBuilder();
    default T copy(Consumer<? super B> p0){ return null; }
}
