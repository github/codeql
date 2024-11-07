// Generated automatically from software.amazon.awssdk.core.async.AsyncRequestBody for testing purposes

package software.amazon.awssdk.core.async;

import java.io.File;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.nio.file.Path;
import java.util.Optional;
import java.util.concurrent.ExecutorService;
import org.reactivestreams.Publisher;
import software.amazon.awssdk.core.async.BlockingInputStreamAsyncRequestBody;
import software.amazon.awssdk.core.async.BlockingOutputStreamAsyncRequestBody;
import software.amazon.awssdk.core.async.SdkPublisher;

public interface AsyncRequestBody extends SdkPublisher<ByteBuffer>
{
    Optional<Long> contentLength();
    default String contentType(){ return null; }
    static AsyncRequestBody empty(){ return null; }
    static AsyncRequestBody fromByteBuffer(ByteBuffer p0){ return null; }
    static AsyncRequestBody fromBytes(byte[] p0){ return null; }
    static AsyncRequestBody fromFile(File p0){ return null; }
    static AsyncRequestBody fromFile(Path p0){ return null; }
    static AsyncRequestBody fromInputStream(InputStream p0, Long p1, ExecutorService p2){ return null; }
    static AsyncRequestBody fromPublisher(Publisher<ByteBuffer> p0){ return null; }
    static AsyncRequestBody fromString(String p0){ return null; }
    static AsyncRequestBody fromString(String p0, Charset p1){ return null; }
    static BlockingInputStreamAsyncRequestBody forBlockingInputStream(Long p0){ return null; }
    static BlockingOutputStreamAsyncRequestBody forBlockingOutputStream(Long p0){ return null; }
}
