// Generated automatically from software.amazon.awssdk.core.async.BlockingInputStreamAsyncRequestBody for testing purposes

package software.amazon.awssdk.core.async;

import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.Optional;
import org.reactivestreams.Subscriber;
import software.amazon.awssdk.core.async.AsyncRequestBody;

public class BlockingInputStreamAsyncRequestBody implements AsyncRequestBody
{
    protected BlockingInputStreamAsyncRequestBody() {}
    public Optional<Long> contentLength(){ return null; }
    public long writeInputStream(InputStream p0){ return 0; }
    public void cancel(){}
    public void subscribe(Subscriber<? super ByteBuffer> p0){}
}
