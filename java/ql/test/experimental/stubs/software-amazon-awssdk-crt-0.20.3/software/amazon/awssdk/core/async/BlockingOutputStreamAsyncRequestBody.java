// Generated automatically from software.amazon.awssdk.core.async.BlockingOutputStreamAsyncRequestBody for testing purposes

package software.amazon.awssdk.core.async;

import java.nio.ByteBuffer;
import java.util.Optional;
import org.reactivestreams.Subscriber;
import software.amazon.awssdk.core.async.AsyncRequestBody;
import software.amazon.awssdk.utils.CancellableOutputStream;

public class BlockingOutputStreamAsyncRequestBody implements AsyncRequestBody
{
    protected BlockingOutputStreamAsyncRequestBody() {}
    public CancellableOutputStream outputStream(){ return null; }
    public Optional<Long> contentLength(){ return null; }
    public void subscribe(Subscriber<? super ByteBuffer> p0){}
}
