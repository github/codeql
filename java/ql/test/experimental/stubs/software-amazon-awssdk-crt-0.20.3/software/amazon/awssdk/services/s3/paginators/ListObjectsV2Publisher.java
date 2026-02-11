// Generated automatically from software.amazon.awssdk.services.s3.paginators.ListObjectsV2Publisher for testing purposes

package software.amazon.awssdk.services.s3.paginators;

import org.reactivestreams.Subscriber;
import software.amazon.awssdk.core.async.SdkPublisher;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.model.CommonPrefix;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Request;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Response;
import software.amazon.awssdk.services.s3.model.S3Object;

public class ListObjectsV2Publisher implements SdkPublisher<ListObjectsV2Response>
{
    protected ListObjectsV2Publisher() {}
    public ListObjectsV2Publisher(S3AsyncClient p0, ListObjectsV2Request p1){}
    public final SdkPublisher<CommonPrefix> commonPrefixes(){ return null; }
    public final SdkPublisher<S3Object> contents(){ return null; }
    public void subscribe(Subscriber<? super ListObjectsV2Response> p0){}
}
