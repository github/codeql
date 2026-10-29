// Generated automatically from software.amazon.awssdk.services.s3.paginators.ListObjectVersionsPublisher for testing purposes

package software.amazon.awssdk.services.s3.paginators;

import org.reactivestreams.Subscriber;
import software.amazon.awssdk.core.async.SdkPublisher;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.model.CommonPrefix;
import software.amazon.awssdk.services.s3.model.DeleteMarkerEntry;
import software.amazon.awssdk.services.s3.model.ListObjectVersionsRequest;
import software.amazon.awssdk.services.s3.model.ListObjectVersionsResponse;
import software.amazon.awssdk.services.s3.model.ObjectVersion;

public class ListObjectVersionsPublisher implements SdkPublisher<ListObjectVersionsResponse>
{
    protected ListObjectVersionsPublisher() {}
    public ListObjectVersionsPublisher(S3AsyncClient p0, ListObjectVersionsRequest p1){}
    public final SdkPublisher<CommonPrefix> commonPrefixes(){ return null; }
    public final SdkPublisher<DeleteMarkerEntry> deleteMarkers(){ return null; }
    public final SdkPublisher<ObjectVersion> versions(){ return null; }
    public void subscribe(Subscriber<? super ListObjectVersionsResponse> p0){}
}
