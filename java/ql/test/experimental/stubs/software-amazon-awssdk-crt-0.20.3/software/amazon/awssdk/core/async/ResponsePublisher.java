// Generated automatically from software.amazon.awssdk.core.async.ResponsePublisher for testing purposes

package software.amazon.awssdk.core.async;

import java.nio.ByteBuffer;
import org.reactivestreams.Subscriber;
import software.amazon.awssdk.core.SdkResponse;
import software.amazon.awssdk.core.async.SdkPublisher;

public class ResponsePublisher<ResponseT extends SdkResponse> implements SdkPublisher<ByteBuffer>
{
    protected ResponsePublisher() {}
    public ResponsePublisher(ResponseT p0, SdkPublisher<ByteBuffer> p1){}
    public ResponseT response(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public void subscribe(Subscriber<? super ByteBuffer> p0){}
}
