// Generated automatically from software.amazon.awssdk.http.async.SdkHttpContentPublisher for testing purposes

package software.amazon.awssdk.http.async;

import java.nio.ByteBuffer;
import java.util.Optional;
import org.reactivestreams.Publisher;

public interface SdkHttpContentPublisher extends Publisher<ByteBuffer>
{
    Optional<Long> contentLength();
}
