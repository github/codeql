// Generated automatically from software.amazon.awssdk.services.s3.paginators.ListMultipartUploadsPublisher for testing purposes

package software.amazon.awssdk.services.s3.paginators;

import org.reactivestreams.Subscriber;
import software.amazon.awssdk.core.async.SdkPublisher;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.model.CommonPrefix;
import software.amazon.awssdk.services.s3.model.ListMultipartUploadsRequest;
import software.amazon.awssdk.services.s3.model.ListMultipartUploadsResponse;
import software.amazon.awssdk.services.s3.model.MultipartUpload;

public class ListMultipartUploadsPublisher implements SdkPublisher<ListMultipartUploadsResponse>
{
    protected ListMultipartUploadsPublisher() {}
    public ListMultipartUploadsPublisher(S3AsyncClient p0, ListMultipartUploadsRequest p1){}
    public final SdkPublisher<CommonPrefix> commonPrefixes(){ return null; }
    public final SdkPublisher<MultipartUpload> uploads(){ return null; }
    public void subscribe(Subscriber<? super ListMultipartUploadsResponse> p0){}
}
